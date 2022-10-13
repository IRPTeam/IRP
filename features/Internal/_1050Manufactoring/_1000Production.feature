#language: en
@tree
@ProductionPlanningAndProduction

Feature: production planning


Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I open new TestClient session or connect the existing one

Scenario: _1001 preparation
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	When change interface localization code for CI
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	When Create catalog AddAttributeAndPropertySets objects (MF)
	When Create catalog AddAttributeAndPropertyValues objects (MF)
	When Create catalog ItemTypes objects (MF)
	When Create catalog Items objects (MF)
	When Create catalog Units objects (MF)
	When Create catalog ItemKeys objects (MF)
	When Create chart of characteristic types AddAttributeAndProperty objects (MF)
	When Create catalog Stores objects
	When Create catalog Companies objects (Main company)
	When Create chart of characteristic types CurrencyMovementType objects
	When Create catalog Currencies objects
	When Create catalog BusinessUnits objects (MF)
	When Create catalog Countries objects
	When Create catalog IntegrationSettings objects
	When Create information register CurrencyRates records
	When update ItemKeys
	When Create catalog MFBillOfMaterials objects


Scenario: _1005 create Bill of materials for semiproduct
	And In the command interface I select "Manufacturing" "Bill of materials"
	* Bill of materials for semiproduct
		* Копыта на стремянки Класс 20х20, черный (Test 1)
			And I click the button named "FormCreate"
			And I input "01 Копыта на стремянки Класс 20х20 (Test 1)" text in "RU" field
			And I click Choice button of the field named "Item"
			And I go to line in "List" table
				| 'Description'                             |
				| 'Копыта на стремянки Класс 20х20, черный' |
			And I select current line in "List" table
			And I click Choice button of the field named "ItemKey"
			And I close "Item keys" window		
			Then the form attribute named "ItemKey" became equal to "Стандартный"
			Then the form attribute named "Unit" became equal to "шт"
			Then the form attribute named "Quantity" became equal to "1,000"
			And in the table "Content" I click the button named "ContentAdd"
			And I click choice button of the attribute named "ContentItem" in "Content" table
			And I go to line in "List" table
				| 'Description' |
				| 'ПВД 158'     |
			And I select current line in "List" table
			And I activate field named "ContentQuantity" in "Content" table
			And I select current line in "Content" table
			And I input "0,980" text in the field named "ContentQuantity" of "Content" table
			And I finish line editing in "Content" table
			And "Content" table became equal
				| '#' | 'Item'    | 'Item key'    | 'Unit' | 'Quantity'     | 'Bill of materials' |
				| '1' | 'ПВД 158' | 'Стандартный' | 'кг'   | '0,980'        | ''                  |
			And I click Select button of "Business unit" field
			And I go to line in "List" table
				| 'Description' |
				| 'Цех 07'      |
			And I select current line in "List" table		
			And I click "Save and close" button
		* Creation check
			And "List" table contains lines
				| 'Description'                                 |  'Item'                                    | 'Item key'    |
				| '01 Копыта на стремянки Класс 20х20 (Test 1)' | 'Копыта на стремянки Класс 20х20, черный'  | 'Стандартный' |
		And I close all client application windows
		

Scenario: _1006 create Bill of materials for product
		And I close all client application windows
		And In the command interface I select "Manufacturing" "Bill of materials"
		* Стремянка CLASS PLUS 5 ступенчатая (Test 2)
			And I click the button named "FormCreate"
			And I input "Стремянка CLASS PLUS 5 ступенчатая (Test 2)" text in "RU" field
			And I click Choice button of the field named "Item"
			And I go to line in "List" table
				| 'Description'                             |
				| 'Стремянка CLASS PLUS 5 ступенчатая' |
			And I select current line in "List" table
			And I click Choice button of the field named "ItemKey"
			And I close "Item keys" window
			Then the form attribute named "ItemKey" became equal to "Perilla"
			Then the form attribute named "Unit" became equal to "шт"
			Then the form attribute named "Quantity" became equal to "1,000"
			And in the table "Content" I click the button named "ContentAdd"
			And I click choice button of the attribute named "ContentItem" in "Content" table
			And I go to line in "List" table
				| 'Description' |
				| 'Заклепка 6х47 полупустотелая'     |
			And I select current line in "List" table
			And I activate field named "ContentQuantity" in "Content" table
			And I select current line in "Content" table
			And I input "15,000" text in the field named "ContentQuantity" of "Content" table
			And I finish line editing in "Content" table
			And in the table "Content" I click the button named "ContentAdd"
			And I click choice button of the attribute named "ContentItem" in "Content" table
			And I go to line in "List" table
				| 'Description' |
				| 'Скобы 3515 (Упаковочные)'     |
			And I select current line in "List" table
			And I activate field named "ContentQuantity" in "Content" table
			And I select current line in "Content" table
			And I input "10,000" text in the field named "ContentQuantity" of "Content" table
			And I finish line editing in "Content" table
			And in the table "Content" I click the button named "ContentAdd"
			And I click choice button of the attribute named "ContentItem" in "Content" table
			And I go to line in "List" table
				| 'Description' |
				| 'Втулка на стремянки Класс 10 мм, черный'     |
			And I select current line in "List" table
			And I activate field named "ContentQuantity" in "Content" table
			And I select current line in "Content" table
			And I input "5,000" text in the field named "ContentQuantity" of "Content" table
			And I finish line editing in "Content" table
			And in the table "Content" I click the button named "ContentAdd"
			And I click choice button of the attribute named "ContentItem" in "Content" table
			And I go to line in "List" table
				| 'Description' |
				| 'Катанка Ст3сп 6,5'     |
			And I select current line in "List" table
			And I activate field named "ContentQuantity" in "Content" table
			And I select current line in "Content" table
			And I input "2,000" text in the field named "ContentQuantity" of "Content" table
			And I finish line editing in "Content" table
			And in the table "Content" I click the button named "ContentAdd"
			And I click choice button of the attribute named "ContentItem" in "Content" table
			And I go to line in "List" table
				| 'Description' |
				| 'Краска порошковая серая 9006'     |
			And I select current line in "List" table
			And I activate field named "ContentQuantity" in "Content" table
			And I select current line in "Content" table
			And I input "1,000" text in the field named "ContentQuantity" of "Content" table
			And I finish line editing in "Content" table
			And in the table "Content" I click the button named "ContentAdd"
			And I click choice button of the attribute named "ContentItem" in "Content" table
			And I go to line in "List" table
				| 'Description' |
				| 'труба электросварная круглая 10х1х5660'     |
			And I select current line in "List" table
			And I activate field named "ContentQuantity" in "Content" table
			And I select current line in "Content" table
			And I input "2,000" text in the field named "ContentQuantity" of "Content" table
			And I finish line editing in "Content" table
			And in the table "Content" I click the button named "ContentAdd"
			And I click choice button of the attribute named "ContentItem" in "Content" table
			And I go to line in "List" table
				| 'Description' |
				| 'Копыта на стремянки Класс 20х20, черный'     |
			And I select current line in "List" table
			And I activate field named "ContentQuantity" in "Content" table
			And I select current line in "Content" table
			And I input "2,000" text in the field named "ContentQuantity" of "Content" table
			And I activate "Bill of materials" field in "Content" table
			And I click choice button of "Bill of materials" attribute in "Content" table
			And I go to line in "List" table
				| 'Description'                        | 'Item'                                    | 'Item key'    |
				| '01 Копыта на стремянки Класс 20х20' | 'Копыта на стремянки Класс 20х20, черный' | 'Стандартный' |
			And I select current line in "List" table	
			And I finish line editing in "Content" table
			And "Content" table became equal
				| '#' | 'Item'                                    | 'Item key'    | 'Unit' | 'Quantity' | 'Bill of materials'                  |
				| '1' | 'Заклепка 6х47 полупустотелая'            | 'Стандартный' | 'шт'   | '15,000'   | ''                                   |
				| '2' | 'Скобы 3515 (Упаковочные)'                | 'Стандартный' | 'шт'   | '10,000'   | ''                                   |
				| '3' | 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный' | 'шт'   | '5,000'    | ''                                   |
				| '4' | 'Катанка Ст3сп 6,5'                       | 'Стандартный' | 'кг'   | '2,000'    | ''                                   |
				| '5' | 'Краска порошковая серая 9006'            | 'Стандартный' | 'кг'   | '1,000'    | ''                                   |
				| '6' | 'труба электросварная круглая 10х1х5660'  | 'Стандартный' | 'шт'   | '2,000'    | ''                                   |
				| '7' | 'Копыта на стремянки Класс 20х20, черный' | 'Стандартный' | 'шт'   | '2,000'    | '01 Копыта на стремянки Класс 20х20' |
			And I click Select button of "Business unit" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Склад производства 05' |
			And I select current line in "List" table
			Then the form attribute named "BusinessUnitReleaseStore" became equal to "Store 01"		
			Then the form attribute named "BusinessUnitSemiproductStore" became equal to "Store 04"
			Then the form attribute named "BusinessUnitMaterialStore" became equal to "Store 07"				
			And I click "Save and close" button		
	* Creation check
		And "List" table contains lines
			| 'Description'                                 | 'Item'                               | 'Item key' |
			| 'Стремянка CLASS PLUS 5 ступенчатая (Test 2)' | 'Стремянка CLASS PLUS 5 ступенчатая' | 'Perilla'  |
		And I close all client application windows
		
Scenario: _1010 create document Production planning
	And In the command interface I select "Manufacturing" "Production planning"
	* Production planning First month
		And I click the button named "FormCreate"
		* Filling in header info
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Main Company' |
			And I select current line in "List" table
			And I click Select button of "Business unit" field
			And I go to line in "List" table
				| 'Description' |
				| 'Склад производства 05'     |
			And I select current line in "List" table
			And I click Select button of "Planning period" field
			And I click the button named "FormCreate"
			And I input "First month" text in "Description" field
			And I input begin of the current month date in "Begin date" field
			And I input end of the current month date in "End date" field
			And I save the value of "Begin date" field as "$$StartDateFirstMonth$$"
			And I save the value of "End date" field as "$$EndDateFirstMonth$$"
			And "BusinessUnits" table became equal
				| 'Business unit'         |
				| 'Склад производства 05' |
			And I click "Save and close" button
			And I click the button named "FormChoose"
			Then the form attribute named "PlanningPeriod" became equal to "First month"
			Then the form attribute named "PlanningPeriodStartDate" became equal to "$$StartDateFirstMonth$$"
			Then the form attribute named "PlanningPeriodEndDate" became equal to "$$EndDateFirstMonth$$"
		* Filling in item tab
			And in the table "Productions" I click the button named "ProductionsAdd"
			And I click choice button of "Item" attribute in "Productions" table
			Then "Items" window is opened
			And I go to line in "List" table
				| 'Description'                        |
				| 'Стремянка CLASS PLUS 6 ступенчатая' |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate "Q" field in "Productions" table
			And I input "100,000" text in "Q" field of "Productions" table
			And I finish line editing in "Productions" table
			And in the table "Productions" I click the button named "ProductionsAdd"
			And I click choice button of "Item" attribute in "Productions" table
			And I go to line in "List" table
				| 'Description'                        |
				| 'Стремянка CLASS PLUS 5 ступенчатая' |
			And I select current line in "List" table
			And I activate "Q" field in "Productions" table
			And I input "250,000" text in "Q" field of "Productions" table
			And I click choice button of "Bill of materials" attribute in "Productions" table
			And I go to line in "List" table
				| 'Description'                        | 'Item'                               | 'Item key' |
				| 'Стремянка CLASS PLUS 5 ступенчатая' | 'Стремянка CLASS PLUS 5 ступенчатая' | 'Perilla'  |
			And I select current line in "List" table		
			And I finish line editing in "Productions" table
			And "Productions" table contains lines
				| 'Item'                               | 'Item key' | 'Unit' | 'Q'       | 'Bill of materials'                  |
				| 'Стремянка CLASS PLUS 6 ступенчатая' | 'Perilla'  | 'шт'   | '100,000' | 'Стремянка CLASS PLUS 6 ступенчатая' |
				| 'Стремянка CLASS PLUS 5 ступенчатая' | 'Perilla'  | 'шт'   | '250,000' | 'Стремянка CLASS PLUS 5 ступенчатая' |
			* Change production store and write off store
				And in the table "Productions" I click "Edit stores" button
				And I expand current line in "ProductionTree" table
				And I expand a line in "ProductionTree" table
					| 'Item'                                                 | 'Quantity' | 'Surplus store' | 'Unit' | 'Writeoff store' |
					| 'Копыта на стремянки Класс 20х20, черный, Стандартный' | '200,000'  | 'Store 01'      | 'шт'   | 'Store 04'       |
				And I expand a line in "ProductionTree" table
					| 'Item'                                                 | 'Quantity' | 'Surplus store' | 'Unit' | 'Writeoff store' |
					| 'Копыта на стремянки Класс 30х20, черный, Стандартный' | '200,000'  | 'Store 01'      | 'шт'   | 'Store 04'       |
				And I activate "Surplus store" field in "ProductionTree" table
				And I select current line in "ProductionTree" table
				And I click choice button of "Surplus store" attribute in "ProductionTree" table
				And I go to line in "List" table
					| 'Description' |
					| 'Store 01'    | 
				And I select current line in "List" table
				And I finish line editing in "ProductionTree" table
				And I go to line in "ProductionTree" table
					| 'Item'                                      | 'Quantity'  | 'Unit' | 'Writeoff store' |
					| 'Заклепка 6х47 полупустотелая, Стандартный' | '1 500,000' | 'шт'   | 'Store 07'       |
				And I activate "Writeoff store" field in "ProductionTree" table
				And I select current line in "ProductionTree" table
				And I click choice button of "Writeoff store" attribute in "ProductionTree" table
				Then "Stores" window is opened
				And I go to line in "List" table
					| 'Description'|
					| 'Store 04'   |
				And I select current line in "List" table
				Then "Edit stores" window is opened
				And I finish line editing in "ProductionTree" table
				And I click "Ok" button					
			And I click the button named "FormPost"
			And I delete "$$NumberProductionPlanning01103110$$" variable
			And I delete "$$ProductionPlanning01103110$$" variable
			And I save the value of "Number" field as "$$NumberProductionPlanning01103110$$"
			And I save the window as "$$ProductionPlanning01103110$$"
			And I click the button named "FormPostAndClose"
	* Production planning Second month
		And I click the button named "FormCreate"
		* Filling in header info
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description' |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Select button of "Business unit" field
			And I go to line in "List" table
				| 'Description' |
				| 'Склад производства 05'     |
			And I select current line in "List" table
			And I click Select button of "Planning period" field
			And I click the button named "FormCreate"
			And I input "Second month" text in "Description" field
			And I input begin of the next month date in "Begin date" field
			And I input end of the next month date in "End date" field
			And I save the value of "Begin date" field as "$$StartDateSecondMonth$$"
			And I save the value of "End date" field as "$$EndDateSecondMonth$$"
			And I click "Save and close" button
			And I click the button named "FormChoose"
			Then the form attribute named "PlanningPeriod" became equal to "Second month"
			Then the form attribute named "PlanningPeriodStartDate" became equal to "$$StartDateSecondMonth$$"
			And the editing text of form attribute named "PlanningPeriodEndDate" became equal to "$$EndDateSecondMonth$$"
		* Filling in item tab
			And in the table "Productions" I click the button named "ProductionsAdd"
			And I click choice button of "Item" attribute in "Productions" table
			Then "Items" window is opened
			And I go to line in "List" table
				| 'Description'                        |
				| 'Стремянка CLASS PLUS 6 ступенчатая' |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate "Q" field in "Productions" table
			And I input "122,000" text in "Q" field of "Productions" table
			And I finish line editing in "Productions" table
			And in the table "Productions" I click the button named "ProductionsAdd"
			And I click choice button of "Item" attribute in "Productions" table
			And I go to line in "List" table
				| 'Description'                        |
				| 'Стремянка CLASS PLUS 5 ступенчатая' |
			And I select current line in "List" table
			And I activate "Q" field in "Productions" table
			And I input "233,000" text in "Q" field of "Productions" table
			And I click choice button of "Bill of materials" attribute in "Productions" table
			And I go to line in "List" table
				| 'Description'                        | 'Item'                               | 'Item key' |
				| 'Стремянка CLASS PLUS 5 ступенчатая' | 'Стремянка CLASS PLUS 5 ступенчатая' | 'Perilla'  |
			And I select current line in "List" table
			And I finish line editing in "Productions" table
			And "Productions" table contains lines
				| 'Item'                               | 'Item key' | 'Unit' | 'Q'       | 'Bill of materials'                  |
				| 'Стремянка CLASS PLUS 6 ступенчатая' | 'Perilla'  | 'шт'   | '122,000' | 'Стремянка CLASS PLUS 6 ступенчатая' |
				| 'Стремянка CLASS PLUS 5 ступенчатая' | 'Perilla'  | 'шт'   | '233,000' | 'Стремянка CLASS PLUS 5 ступенчатая' |
			* Check filling stores
				And in the table "Productions" I click "Edit stores" button
				And I expand current line in "ProductionTree" table
				And I expand a line in "ProductionTree" table
					| 'Item'                                                 | 'Quantity' | 'Surplus store' | 'Unit' | 'Writeoff store'        |
					| 'Копыта на стремянки Класс 20х20, черный, Стандартный' | '244,000'  | 'Store 01'      | 'шт'   | 'Store 04'              |
				And I expand a line in "ProductionTree" table
					| 'Item'                                                 | 'Quantity' | 'Surplus store' | 'Unit' | 'Writeoff store'        |
					| 'Копыта на стремянки Класс 30х20, черный, Стандартный' | '244,000'  | 'Store 01'      | 'шт'   | 'Store 04'              |
				And "ProductionTree" table became equal
					| 'Item'                                                 | 'Surplus store' | 'Writeoff store' | 'Unit' | 'Quantity'  |
					| 'Стремянка CLASS PLUS 6 ступенчатая, Perilla'          | 'Store 01'      | ''               | 'шт'   | '122,000'   |
					| 'Заклепка 6х47 полупустотелая, Стандартный'            | ''              | 'Store 07'       | 'шт'   | '1 830,000' |
					| 'Скобы 3515 (Упаковочные), Стандартный'                | ''              | 'Store 07'       | 'шт'   | '1 220,000' |
					| 'Втулка на стремянки Класс 10 мм, черный, Стандартный' | ''              | 'Store 07'       | 'шт'   | '610,000'   |
					| 'Катанка Ст3сп 6,5, Стандартный'                       | ''              | 'Store 07'       | 'кг'   | '244,000'   |
					| 'Краска порошковая серая 9006, Стандартный'            | ''              | 'Store 07'       | 'кг'   | '122,000'   |
					| 'труба электросварная круглая 10х1х5660, Стандартный'  | ''              | 'Store 07'       | 'шт'   | '244,000'   |
					| 'Копыта на стремянки Класс 20х20, черный, Стандартный' | 'Store 01'      | 'Store 04'       | 'шт'   | '244,000'   |
					| 'ПВД 158, Стандартный'                                 | ''              | 'Store 07'       | 'кг'   | '239,120'   |
					| 'Коврик для стремянок Класс, черный, Стандартный'      | ''              | 'Store 07'       | 'шт'   | '122,000'   |
					| 'Копыта на стремянки Класс 30х20, черный, Стандартный' | 'Store 01'      | 'Store 04'       | 'шт'   | '244,000'   |
					| 'ПВД 158, Стандартный'                                 | ''              | 'Store 02'       | 'кг'   | '463,600'   |
				And I close current window					
			And I click the button named "FormPost"
			And I delete "$$NumberProductionPlanning01113011$$" variable
			And I delete "$$ProductionPlanning01113011$$" variable
			And I save the value of "Number" field as "$$NumberProductionPlanning01113011$$"
			And I save the window as "$$ProductionPlanning01113011$$"
			And I click the button named "FormPostAndClose"
	* Production planning Third month
		And I click the button named "FormCreate"
		* Filling in header info
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description' |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Select button of "Business unit" field
			And I go to line in "List" table
				| 'Description' |
				| 'Склад производства 05'     |
			And I select current line in "List" table
			// And I click Select button of "Store material" field
			// And I go to line in "List" table
			// 	| 'Description' |
			// 	| 'Store 05'     |
			// And I select current line in "List" table
			// And I click Select button of "Store production" field
			// And I go to line in "List" table
			// 	| 'Description' |
			// 	| 'Склад готовой продукции'     |
			// And I select current line in "List" table
			And I click Select button of "Planning period" field
			And I click the button named "FormCreate"
			And I input "Third month" text in "Description" field
			And I save "Format((EndOfMonth(CurrentDate()) + 2764800), \"DF=dd.MM.yyyy\")" in "$$DateStartThirdMonth$$" variable
			And I save "Format((EndOfMonth(CurrentDate()) + 5356800), \"DF=dd.MM.yyyy\")" in "$$$$DateEndThirdMonth$$$$" variable
			And I input "$$$$DateStartThirdMonth$$$$" variable value in "Begin date" field
			And I input "$$$$DateEndThirdMonth$$$$" variable value in "End date" field
			And I click "Save and close" button
			And I click the button named "FormChoose"
			Then the form attribute named "PlanningPeriod" became equal to "Third month"
			Then the form attribute named "PlanningPeriodStartDate" became equal to "$$$$DateStartThirdMonth$$$$"
			And the editing text of form attribute named "PlanningPeriodEndDate" became equal to "$$$$DateEndThirdMonth$$$$"
		* Filling in item tab
			And in the table "Productions" I click the button named "ProductionsAdd"
			And I click choice button of "Item" attribute in "Productions" table
			And I go to line in "List" table
				| 'Description'                        |
				| 'Стремянка CLASS PLUS 8' |
			And I select current line in "List" table
			And I activate "Q" field in "Productions" table
			And I input "131,000" text in "Q" field of "Productions" table
			And I activate "Bill of materials" field in "Productions" table
			And I click choice button of "Bill of materials" attribute in "Productions" table
			And I go to line in "List" table
				| 'Description'            | 'Item'                   | 'Item key' |
				| 'Стремянка CLASS PLUS 8 (основная)' | 'Стремянка CLASS PLUS 8' | 'Perilla'  |
			And I select current line in "List" table
			And I finish line editing in "Productions" table
			And "Productions" table contains lines
				| 'Item'                   | 'Item key' | 'Unit' | 'Q'       | 'Bill of materials'                 |
				| 'Стремянка CLASS PLUS 8' | 'Perilla'  | 'шт'   | '131,000' | 'Стремянка CLASS PLUS 8 (основная)' |
			And I click the button named "FormPost"
			And I delete "$$NumberProductionPlanning01123112$$" variable
			And I delete "$$ProductionPlanning01123112$$" variable
			And I save the value of "Number" field as "$$NumberProductionPlanning01123112$$"
			And I save the window as "$$ProductionPlanning01123112$$"
			And I click the button named "FormPostAndClose"
	* Creation check
		And "List" table contains lines
			| 'Number'                               | 'Company'      | 'Business unit'         | 'Planning period' |
			| '$$NumberProductionPlanning01103110$$' | 'Main Company' | 'Склад производства 05' | 'First month'     |
			| '$$NumberProductionPlanning01113011$$' | 'Main Company' | 'Склад производства 05' | 'Second month'    |
			| '$$NumberProductionPlanning01123112$$' | 'Main Company' | 'Склад производства 05' | 'Third month'     |
		And I close all client application windows
		

Scenario: _1011 check Production planning movements
	* Check movements
		And In the command interface I select "Manufacturing" "Production planning"
		And I go to line in "List" table
			| 'Number'                               |
			| '$$NumberProductionPlanning01103110$$' |
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$ProductionPlanning01103110$$'        | ''       | ''                                           | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| 'Document registrations records'        | ''       | ''                                           | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| 'Register  "R7010 Detailing supplies"'  | ''       | ''                                           | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | 'Period' | 'Resources'                                  | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Dimensions'    | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | ''       | 'Entry demand quantity'                      | 'Corrected demand quantity' | 'Needed produce quantity'        | 'Produced produce quantity' | 'Reserved produce quantity' | 'Written off produce quantity' | 'Request procurement quantity'   | 'Order transfer quantity' | 'Confirmed transfer quantity' | 'Order purchase quantity'                    | 'Confirmed purchase quantity' | 'Company'       | 'Business unit'         | 'Store'       | 'Planning period' | 'Item key'       | ''            | ''           | ''                |
			| ''                                      | '*'      | '100'                                        | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 07'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '200'                                        | ''                          | '200'                            | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 04'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '350'                                        | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 07'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '380'                                        | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Цех 06'                | 'Store 02'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '686'                                        | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 07'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '700'                                        | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 07'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '700'                                        | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 07'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '700'                                        | ''                          | '700'                            | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 04'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '1 500'                                      | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 04'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '1 750'                                      | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 07'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '3 500'                                      | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 07'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '3 750'                                      | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 07'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | ''       | ''                                           | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| 'Register  "R7020 Material planning"'   | ''       | ''                                           | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | 'Period' | 'Resources'                                  | 'Dimensions'                | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | ''       | 'Quantity'                                   | 'Company'                   | 'Planning document'              | 'Business unit'             | 'Store'                     | 'Production'                   | 'Item key'                       | 'Planning type'           | 'Planning period'             | 'Bill of materials'                          | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '100'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '100'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '196'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Стандартный'                  | 'Стандартный'                    | 'Planned'                 | 'First month'                 | '01 Копыта на стремянки Класс 20х20'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '200'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 04'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '200'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 04'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '200'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '200'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '250'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 5 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '380'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Цех 06'                    | 'Store 02'                  | 'Стандартный'                  | 'Стандартный'                    | 'Planned'                 | 'First month'                 | '01 Копыта на стремянки Класс 30х20, черный' | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '490'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Стандартный'                  | 'Стандартный'                    | 'Planned'                 | 'First month'                 | '01 Копыта на стремянки Класс 20х20'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '500'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 04'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 5 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '500'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 5 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '500'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 5 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '500'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '1 000'                                      | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '1 250'                                      | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 5 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '1 500'                                      | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 04'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '2 500'                                      | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 5 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '3 750'                                      | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 5 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | ''       | ''                                           | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| 'Register  "R7030 Production planning"' | ''       | ''                                           | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | 'Period' | 'Resources'                                  | 'Dimensions'                | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | ''       | 'Quantity'                                   | 'Company'                   | 'Planning document'              | 'Business unit'             | 'Store'                     | 'Item key'                     | 'Planning type'                  | 'Planning period'         | 'Production type'             | 'Bill of materials'                          | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '100'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 01'                  | 'Perilla'                      | 'Planned'                        | 'First month'             | 'Product'                     | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '200'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 01'                  | 'Стандартный'                  | 'Planned'                        | 'First month'             | 'Semiproduct'                 | '01 Копыта на стремянки Класс 20х20'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '200'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Цех 06'                    | 'Store 01'                  | 'Стандартный'                  | 'Planned'                        | 'First month'             | 'Semiproduct'                 | '01 Копыта на стремянки Класс 30х20, черный' | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '250'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 01'                  | 'Perilla'                      | 'Planned'                        | 'First month'             | 'Product'                     | 'Стремянка CLASS PLUS 5 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '500'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 01'                  | 'Стандартный'                  | 'Planned'                        | 'First month'             | 'Semiproduct'                 | '01 Копыта на стремянки Класс 20х20'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | ''       | ''                                           | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| 'Register  "T7010 Bill of materials"'   | ''       | ''                                           | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | 'Period' | 'Resources'                                  | ''                          | ''                               | ''                          | ''                          | 'Dimensions'                   | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | ''       | 'Bill of materials'                          | 'Unit'                      | 'Quantity'                       | 'Basis unit'                | 'Basis quantity'            | 'Company'                      | 'Planning document'              | 'Business unit'           | 'Input ID'                    | 'Output ID'                                  | 'Unique ID'                   | 'Surplus store' | 'Writeoff store'        | 'Item key'    | 'Is product'      | 'Is semiproduct' | 'Is material' | 'Is service' | 'Planning period' |
			| ''                                      | '*'      | ''                                           | 'шт'                        | '100'                            | 'шт'                        | '100'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'шт'                        | '200'                            | 'шт'                        | '200'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'шт'                        | '500'                            | 'шт'                        | '500'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'шт'                        | '500'                            | 'шт'                        | '500'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'шт'                        | '1 000'                          | 'шт'                        | '1 000'                     | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'шт'                        | '1 250'                          | 'шт'                        | '1 250'                     | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'шт'                        | '1 500'                          | 'шт'                        | '1 500'                     | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 04'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'шт'                        | '2 500'                          | 'шт'                        | '2 500'                     | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'шт'                        | '3 750'                          | 'шт'                        | '3 750'                     | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'кг'                        | '100'                            | 'кг'                        | '100'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'кг'                        | '196'                            | 'кг'                        | '196'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'кг'                        | '200'                            | 'кг'                        | '200'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'кг'                        | '250'                            | 'кг'                        | '250'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'кг'                        | '380'                            | 'кг'                        | '380'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Цех 06'                  | '*'                           | ''                                           | '*'                           | ''              | 'Store 02'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'кг'                        | '490'                            | 'кг'                        | '490'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'кг'                        | '500'                            | 'кг'                        | '500'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | '01 Копыта на стремянки Класс 20х20'         | 'шт'                        | '200'                            | 'шт'                        | '200'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | '*'                                          | '*'                           | 'Store 01'      | 'Store 04'              | 'Стандартный' | 'No'              | 'Yes'            | 'No'          | 'No'         | 'First month'     |
			| ''                                      | '*'      | '01 Копыта на стремянки Класс 20х20'         | 'шт'                        | '500'                            | 'шт'                        | '500'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | '*'                                          | '*'                           | 'Store 01'      | 'Store 04'              | 'Стандартный' | 'No'              | 'Yes'            | 'No'          | 'No'         | 'First month'     |
			| ''                                      | '*'      | '01 Копыта на стремянки Класс 30х20, черный' | 'шт'                        | '200'                            | 'шт'                        | '200'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Цех 06'                  | '*'                           | '*'                                          | '*'                           | 'Store 01'      | 'Store 04'              | 'Стандартный' | 'No'              | 'Yes'            | 'No'          | 'No'         | 'First month'     |
			| ''                                      | '*'      | 'Стремянка CLASS PLUS 5 ступенчатая'         | 'шт'                        | '250'                            | 'шт'                        | '250'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | ''                            | '*'                                          | '*'                           | 'Store 01'      | ''                      | 'Perilla'     | 'Yes'             | 'No'             | 'No'          | 'No'         | 'First month'     |
			| ''                                      | '*'      | 'Стремянка CLASS PLUS 6 ступенчатая'         | 'шт'                        | '100'                            | 'шт'                        | '100'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | ''                            | '*'                                          | '*'                           | 'Store 01'      | ''                      | 'Perilla'     | 'Yes'             | 'No'             | 'No'          | 'No'         | 'First month'     |
		And I close current window
	* Clear movements and check that there is no movement on the registers
		* Clear movements
			Given I open hyperlink "e1cib/list/Document.ProductionPlanning"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberProductionPlanning01103110$$'      |	
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		* Check that there is no movement on the registers
			Given I open hyperlink "e1cib/list/AccumulationRegister.R7030T_ProductionPlanning"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$ProductionPlanning01103110$$' |
			Given I open hyperlink "e1cib/list/InformationRegister.T7010S_BillOfMaterials"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$ProductionPlanning01103110$$' |
			And I close all client application windows
	* Re-posting the document and checking movements on the registers
		* Posting the document
			Given I open hyperlink "e1cib/list/Document.ProductionPlanning"
			And I go to line in "List" table
				| 'Number' |
				| '$$NumberProductionPlanning01103110$$'      |
			And in the table "List" I click the button named "ListContextMenuPost"
		* Check movements
			And I click "Registrations report" button
			And "ResultTable" spreadsheet document contains lines:
			| '$$ProductionPlanning01103110$$'        | ''       | ''                                           | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| 'Document registrations records'        | ''       | ''                                           | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| 'Register  "R7010 Detailing supplies"'  | ''       | ''                                           | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | 'Period' | 'Resources'                                  | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Dimensions'    | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | ''       | 'Entry demand quantity'                      | 'Corrected demand quantity' | 'Needed produce quantity'        | 'Produced produce quantity' | 'Reserved produce quantity' | 'Written off produce quantity' | 'Request procurement quantity'   | 'Order transfer quantity' | 'Confirmed transfer quantity' | 'Order purchase quantity'                    | 'Confirmed purchase quantity' | 'Company'       | 'Business unit'         | 'Store'       | 'Planning period' | 'Item key'       | ''            | ''           | ''                |
			| ''                                      | '*'      | '100'                                        | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 07'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '200'                                        | ''                          | '200'                            | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 04'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '350'                                        | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 07'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '380'                                        | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Цех 06'                | 'Store 02'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '686'                                        | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 07'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '700'                                        | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 07'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '700'                                        | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 07'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '700'                                        | ''                          | '700'                            | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 04'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '1 500'                                      | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 04'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '1 750'                                      | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 07'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '3 500'                                      | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 07'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | '*'      | '3 750'                                      | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | 'Main Company'  | 'Склад производства 05' | 'Store 07'    | 'First month'     | 'Стандартный'    | ''            | ''           | ''                |
			| ''                                      | ''       | ''                                           | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| 'Register  "R7020 Material planning"'   | ''       | ''                                           | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | 'Period' | 'Resources'                                  | 'Dimensions'                | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | ''       | 'Quantity'                                   | 'Company'                   | 'Planning document'              | 'Business unit'             | 'Store'                     | 'Production'                   | 'Item key'                       | 'Planning type'           | 'Planning period'             | 'Bill of materials'                          | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '100'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '100'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '196'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Стандартный'                  | 'Стандартный'                    | 'Planned'                 | 'First month'                 | '01 Копыта на стремянки Класс 20х20'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '200'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 04'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '200'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 04'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '200'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '200'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '250'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 5 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '380'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Цех 06'                    | 'Store 02'                  | 'Стандартный'                  | 'Стандартный'                    | 'Planned'                 | 'First month'                 | '01 Копыта на стремянки Класс 30х20, черный' | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '490'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Стандартный'                  | 'Стандартный'                    | 'Planned'                 | 'First month'                 | '01 Копыта на стремянки Класс 20х20'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '500'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 04'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 5 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '500'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 5 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '500'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 5 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '500'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '1 000'                                      | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '1 250'                                      | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 5 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '1 500'                                      | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 04'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '2 500'                                      | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 5 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '3 750'                                      | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 07'                  | 'Perilla'                      | 'Стандартный'                    | 'Planned'                 | 'First month'                 | 'Стремянка CLASS PLUS 5 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | ''       | ''                                           | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| 'Register  "R7030 Production planning"' | ''       | ''                                           | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | 'Period' | 'Resources'                                  | 'Dimensions'                | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | ''       | 'Quantity'                                   | 'Company'                   | 'Planning document'              | 'Business unit'             | 'Store'                     | 'Item key'                     | 'Planning type'                  | 'Planning period'         | 'Production type'             | 'Bill of materials'                          | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '100'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 01'                  | 'Perilla'                      | 'Planned'                        | 'First month'             | 'Product'                     | 'Стремянка CLASS PLUS 6 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '200'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 01'                  | 'Стандартный'                  | 'Planned'                        | 'First month'             | 'Semiproduct'                 | '01 Копыта на стремянки Класс 20х20'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '200'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Цех 06'                    | 'Store 01'                  | 'Стандартный'                  | 'Planned'                        | 'First month'             | 'Semiproduct'                 | '01 Копыта на стремянки Класс 30х20, черный' | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '250'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 01'                  | 'Perilla'                      | 'Planned'                        | 'First month'             | 'Product'                     | 'Стремянка CLASS PLUS 5 ступенчатая'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | '*'      | '500'                                        | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 01'                  | 'Стандартный'                  | 'Planned'                        | 'First month'             | 'Semiproduct'                 | '01 Копыта на стремянки Класс 20х20'         | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | ''       | ''                                           | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| 'Register  "T7010 Bill of materials"'   | ''       | ''                                           | ''                          | ''                               | ''                          | ''                          | ''                             | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | 'Period' | 'Resources'                                  | ''                          | ''                               | ''                          | ''                          | 'Dimensions'                   | ''                               | ''                        | ''                            | ''                                           | ''                            | ''              | ''                      | ''            | ''                | ''               | ''            | ''           | ''                |
			| ''                                      | ''       | 'Bill of materials'                          | 'Unit'                      | 'Quantity'                       | 'Basis unit'                | 'Basis quantity'            | 'Company'                      | 'Planning document'              | 'Business unit'           | 'Input ID'                    | 'Output ID'                                  | 'Unique ID'                   | 'Surplus store' | 'Writeoff store'        | 'Item key'    | 'Is product'      | 'Is semiproduct' | 'Is material' | 'Is service' | 'Planning period' |
			| ''                                      | '*'      | ''                                           | 'шт'                        | '100'                            | 'шт'                        | '100'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'шт'                        | '200'                            | 'шт'                        | '200'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'шт'                        | '500'                            | 'шт'                        | '500'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'шт'                        | '500'                            | 'шт'                        | '500'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'шт'                        | '1 000'                          | 'шт'                        | '1 000'                     | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'шт'                        | '1 250'                          | 'шт'                        | '1 250'                     | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'шт'                        | '1 500'                          | 'шт'                        | '1 500'                     | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 04'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'шт'                        | '2 500'                          | 'шт'                        | '2 500'                     | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'шт'                        | '3 750'                          | 'шт'                        | '3 750'                     | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'кг'                        | '100'                            | 'кг'                        | '100'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'кг'                        | '196'                            | 'кг'                        | '196'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'кг'                        | '200'                            | 'кг'                        | '200'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'кг'                        | '250'                            | 'кг'                        | '250'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'кг'                        | '380'                            | 'кг'                        | '380'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Цех 06'                  | '*'                           | ''                                           | '*'                           | ''              | 'Store 02'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'кг'                        | '490'                            | 'кг'                        | '490'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | ''                                           | 'кг'                        | '500'                            | 'кг'                        | '500'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | ''                                           | '*'                           | ''              | 'Store 07'              | 'Стандартный' | 'No'              | 'No'             | 'Yes'         | 'No'         | 'First month'     |
			| ''                                      | '*'      | '01 Копыта на стремянки Класс 20х20'         | 'шт'                        | '200'                            | 'шт'                        | '200'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | '*'                                          | '*'                           | 'Store 01'      | 'Store 04'              | 'Стандартный' | 'No'              | 'Yes'            | 'No'          | 'No'         | 'First month'     |
			| ''                                      | '*'      | '01 Копыта на стремянки Класс 20х20'         | 'шт'                        | '500'                            | 'шт'                        | '500'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | '*'                           | '*'                                          | '*'                           | 'Store 01'      | 'Store 04'              | 'Стандартный' | 'No'              | 'Yes'            | 'No'          | 'No'         | 'First month'     |
			| ''                                      | '*'      | '01 Копыта на стремянки Класс 30х20, черный' | 'шт'                        | '200'                            | 'шт'                        | '200'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Цех 06'                  | '*'                           | '*'                                          | '*'                           | 'Store 01'      | 'Store 04'              | 'Стандартный' | 'No'              | 'Yes'            | 'No'          | 'No'         | 'First month'     |
			| ''                                      | '*'      | 'Стремянка CLASS PLUS 5 ступенчатая'         | 'шт'                        | '250'                            | 'шт'                        | '250'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | ''                            | '*'                                          | '*'                           | 'Store 01'      | ''                      | 'Perilla'     | 'Yes'             | 'No'             | 'No'          | 'No'         | 'First month'     |
			| ''                                      | '*'      | 'Стремянка CLASS PLUS 6 ступенчатая'         | 'шт'                        | '100'                            | 'шт'                        | '100'                       | 'Main Company'                 | '$$ProductionPlanning01103110$$' | 'Склад производства 05'   | ''                            | '*'                                          | '*'                           | 'Store 01'      | ''                      | 'Perilla'     | 'Yes'             | 'No'             | 'No'          | 'No'         | 'First month'     |
			And I close all client application windows
		

// Scenario: _1025 create Internal supply request based on Production planning (Production procurement)
// 	And In the command interface I select "Manufacturing" "Production procurement"
// 	And I click Select button of "Production planning" field
// 	And I go to line in "List" table
// 		| 'Number' |
// 		| '$$NumberProductionPlanning01103110$$'      |
// 	And I select current line in "List" table
// 	And Delay 10
// 	And "ProductionTree" table contains lines
// 		| 'Product, Semiproduct, Material, Service'              | 'Procurement'    | 'Basis unit' | 'Unit' | 'Q'         | 'Basis Q'   |
// 		| 'Стремянка CLASS PLUS 6 ступенчатая, Perilla'          | 'Produce'        | 'шт'         | 'шт'   | '100,000'   | '100,000'   |
// 		| 'Заклепка 6х47 полупустотелая, Стандартный'            | 'Supply request' | 'шт'         | 'шт'   | '1 500,000' | '1 500,000' |
// 		| 'Скобы 3515 (Упаковочные), Стандартный'                | 'Supply request' | 'шт'         | 'шт'   | '1 000,000' | '1 000,000' |
// 		| 'Втулка на стремянки Класс 10 мм, черный, Стандартный' | 'Supply request' | 'шт'         | 'шт'   | '500,000'   | '500,000'   |
// 		| 'Катанка Ст3сп 6,5, Стандартный'                       | 'Supply request' | 'кг'         | 'кг'   | '200,000'   | '200,000'   |
// 		| 'Краска порошковая серая 9006, Стандартный'            | 'Supply request' | 'кг'         | 'кг'   | '100,000'   | '100,000'   |
// 		| 'труба электросварная круглая 10х1х5660, Стандартный'  | 'Supply request' | 'шт'         | 'шт'   | '200,000'   | '200,000'   |
// 		| 'Копыта на стремянки Класс 20х20, черный, Стандартный' | 'Produce'        | 'шт'         | 'шт'   | '200,000'   | '200,000'   |
// 		| 'ПВД 158, Стандартный'                                 | 'Supply request' | 'кг'         | 'кг'   | '196,000'   | '196,000'   |
// 		| 'Коврик для стремянок Класс, черный, Стандартный'      | 'Supply request' | 'шт'         | 'шт'   | '100,000'   | '100,000'   |
// 		| 'Копыта на стремянки Класс 30х20, черный, Стандартный' | 'Produce'        | 'шт'         | 'шт'   | '200,000'   | '200,000'   |
// 		| 'ПВД 158, Стандартный'                                 | 'Supply request' | 'кг'         | 'кг'   | '380,000'   | '380,000'   |
// 		| 'Стремянка CLASS PLUS 5 ступенчатая, Perilla'          | 'Produce'        | 'шт'         | 'шт'   | '250,000'   | '250,000'   |
// 		| 'Заклепка 6х47 полупустотелая, Стандартный'            | 'Supply request' | 'шт'         | 'шт'   | '3 750,000' | '3 750,000' |
// 		| 'Скобы 3515 (Упаковочные), Стандартный'                | 'Supply request' | 'шт'         | 'шт'   | '2 500,000' | '2 500,000' |
// 		| 'Втулка на стремянки Класс 10 мм, черный, Стандартный' | 'Supply request' | 'шт'         | 'шт'   | '1 250,000' | '1 250,000' |
// 		| 'Катанка Ст3сп 6,5, Стандартный'                       | 'Supply request' | 'кг'         | 'кг'   | '500,000'   | '500,000'   |
// 		| 'Краска порошковая серая 9006, Стандартный'            | 'Supply request' | 'кг'         | 'кг'   | '250,000'   | '250,000'   |
// 		| 'труба электросварная круглая 10х1х5660, Стандартный'  | 'Supply request' | 'шт'         | 'шт'   | '500,000'   | '500,000'   |
// 		| 'Копыта на стремянки Класс 20х20, черный, Стандартный' | 'Produce'        | 'шт'         | 'шт'   | '500,000'   | '500,000'   |
// 		| 'ПВД 158, Стандартный'                                 | 'Supply request' | 'кг'         | 'кг'   | '490,000'   | '490,000'   |
// 	And in the table "DocumentsSupplyRequest" I click "For all products" button
// 	And "DocumentsSupplyRequest" table contains lines
// 		| 'Supply request'           |
// 		| 'Internal supply request*' |
// 	And I go to the first line in "DocumentsSupplyRequest" table
// 	And I select current line in "DocumentsSupplyRequest" table
// 	And I delete "$$NumberInternalSupplyRequest01103110$$" variable
// 	And I delete "$$InternalSupplyRequest01103110$$" variable
// 	And I save the value of "Number" field as "$$NumberInternalSupplyRequest01103110$$"
// 	And I save the window as "$$InternalSupplyRequest01103110$$"
// 	Then the form attribute named "Company" became equal to "Собственная компания"
// 	Then the form attribute named "Store" became equal to "Store 05"
// 	And "ItemList" table contains lines
// 		| 'Item'                                    | 'Item key'    | 'Quantity'  | 'Unit' |
// 		| 'Заклепка 6х47 полупустотелая'            | 'Стандартный' | '5 250,000' | 'шт'   |
// 		| 'Катанка Ст3сп 6,5'                       | 'Стандартный' | '700,000'   | 'кг'   |
// 		| 'Краска порошковая серая 9006'            | 'Стандартный' | '350,000'   | 'кг'   |
// 		| 'труба электросварная круглая 10х1х5660'  | 'Стандартный' | '700,000'   | 'шт'   |
// 		| 'ПВД 158'                                 | 'Стандартный' | '1 066,000' | 'кг'   |
// 		| 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный' | '1 750,000' | 'шт'   |
// 		| 'Скобы 3515 (Упаковочные)'                | 'Стандартный' | '3 500,000' | 'шт'   |
// 		| 'Коврик для стремянок Класс, черный'      | 'Стандартный' | '100,000'   | 'шт'   |
// 	Then the number of "ItemList" table lines is "меньше или равно" "8"
// 	And I close all client application windows
// 	* Create ISR for one product
// 		And In the command interface I select "Manufacturing" "Production procurement"
// 		And I click Select button of "Production planning" field
// 		And I go to line in "List" table
// 			| 'Number' |
// 			| '$$NumberProductionPlanning01113011$$'      |
// 		And I select current line in "List" table
// 		And Delay 10
// 		And I go to line in "ProductionTree" table
// 			| 'Basis Q' | 'Basis unit' | 'Procurement' | 'Product, Semiproduct, Material, Service'     | 'Q'       | 'Unit' |
// 			| '122,000' | 'шт'         | 'Produce'     | 'Стремянка CLASS PLUS 6 ступенчатая, Perilla' | '122,000' | 'шт'   |
// 		And in the table "DocumentsSupplyRequest" I click "For selected products" button
// 		And "DocumentsSupplyRequest" table contains lines
// 			| 'Supply request'           |
// 			| 'Internal supply request*' |
// 		And I go to the first line in "DocumentsSupplyRequest" table
// 		And I select current line in "DocumentsSupplyRequest" table
// 		And I delete "$$NumberInternalSupplyRequest01103111$$" variable
// 		And I delete "$$InternalSupplyRequest01103111$$" variable
// 		And I save the value of "Number" field as "$$NumberInternalSupplyRequest01103111$$"
// 		And I save the window as "$$InternalSupplyRequest01103110$$"
// 		Then the form attribute named "Company" became equal to "Собственная компания"
// 		Then the form attribute named "Store" became equal to "Store 05"
// 		And "ItemList" table contains lines
// 			| 'Item'                                    | 'Item key'    | 'Quantity'  | 'Unit' |
// 			| 'труба электросварная круглая 10х1х5660'  | 'Стандартный' | '244,000'   | 'шт'   |
// 			| 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный' | '610,000'   | 'шт'   |
// 			| 'Скобы 3515 (Упаковочные)'                | 'Стандартный' | '1 220,000' | 'шт'   |
// 			| 'Заклепка 6х47 полупустотелая'            | 'Стандартный' | '1 830,000' | 'шт'   |
// 			| 'Катанка Ст3сп 6,5'                       | 'Стандартный' | '244,000'   | 'кг'   |
// 			| 'Коврик для стремянок Класс, черный'      | 'Стандартный' | '122,000'   | 'шт'   |
// 			| 'Краска порошковая серая 9006'            | 'Стандартный' | '122,000'   | 'кг'   |
// 			| 'ПВД 158'                                 | 'Стандартный' | '702,720'   | 'кг'   |
// 		Then the number of "ItemList" table lines is "меньше или равно" "8"
// 		And I close all client application windows

// Scenario: _1026 check for Internal supply request double creation
// 	And In the command interface I select "Manufacturing" "Production procurement"
// 	And I click Select button of "Production planning" field
// 	And I go to line in "List" table
// 		| 'Number' |
// 		| '$$NumberProductionPlanning01103110$$'      |
// 	And I select current line in "List" table
// 	And in the table "DocumentsSupplyRequest" I click "For all products" button
// 	And "DocumentsSupplyRequest" table contains lines
// 		| 'Supply request'           |
// 		| '$$InternalSupplyRequest01103110$$' |
// 	Then the number of "DocumentsSupplyRequest" table lines is "меньше или равно" "1"
// 	And I close all client application windows

Scenario: _1035 create document Production
	* Semiproduct
		And In the command interface I select "Manufacturing" "Production"
		And I click the button named "FormCreate"
		* Filling in header info
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description' |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Select button of "Business unit" field
			And I go to line in "List" table
				| 'Description' |
				| 'Склад производства 05'     |
			And I select current line in "List" table
			And I click Select button of "Production planning" field
			And I go to line in "List" table
				| 'Number'                               |
				| '$$NumberProductionPlanning01103110$$' |
			And I select current line in "List" table
			Then the form attribute named "PlanningPeriod" became equal to "First month"
		* Filling in production tab
			And I move to "Production" tab
			And I click Choice button of the field named "Item"
			And I go to line in "List" table
				| 'Description'                        |
				| 'Копыта на стремянки Класс 20х20, черный' |
			And I select current line in "List" table
			Then the form attribute named "ItemKey" became equal to "Стандартный"
			And I click Select button of "Bill of materials" field
			And I go to line in "List" table
				| 'Description'                        | 'Item'                                    |
				| '01 Копыта на стремянки Класс 20х20' | 'Копыта на стремянки Класс 20х20, черный' |
			And I select current line in "List" table		
			
			Then the form attribute named "Unit" became equal to "шт"
			And I input "20,000" text in the field named "Quantity"
			And I move to "Materials" tab	
			And "Materials" table contains lines
				| '#' | 'Item'    | 'Item key'    | 'Unit' | 'Q'     |
				| '1' | 'ПВД 158' | 'Стандартный' | 'кг'   | '19,600' |					
			Then the number of "Materials" table lines is "меньше или равно" "1"
			And I click Select button of "Store production" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 05'    |
			And I select current line in "List" table
			And I select current line in "Materials" table
			And I select "Material" exact value from "Material type" drop-down list in "Materials" table
			And I activate field named "MaterialsLineNumber" in "Materials" table
			And I activate "Material type" field in "Materials" table	
			And I activate "Writeoff store" field in "Materials" table
			And I select current line in "Materials" table
			And I click choice button of "Writeoff store" attribute in "Materials" table
			And I go to line in "List" table
				| 'Description' |
				| 'Store 05'    |
			And I select current line in "List" table							
			And I click the button named "FormPost"
			And I delete "$$NumberProduction02$$" variable
			And I delete "$$Production02$$" variable
			And I delete "$$DateProduction02$$" variable
			And I save the value of "Number" field as "$$NumberProduction02$$"
			And I save the window as "$$Production02$$"
			And I save the value of the field named "Date" as "$$DateProduction02$$"
		* Check movements
			And I click "Registrations report" button
			And I select "R4011 Free stocks" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| 'Register  "R4011 Free stocks"' | ''            | ''                     | ''          | ''           | ''            |
				| ''                              | 'Record type' | 'Period'               | 'Resources' | 'Dimensions' | ''            |
				| ''                              | ''            | ''                     | 'Quantity'  | 'Store'      | 'Item key'    |
				| ''                              | 'Receipt'     | '$$DateProduction02$$' | '20'        | 'Store 05'   | 'Стандартный' |
				| ''                              | 'Expense'     | '$$DateProduction02$$' | '19,6'      | 'Store 05'   | 'Стандартный' |
			And I select "R4010 Actual stocks" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| 'Register  "R4010 Actual stocks"' | ''            | ''                     | ''          | ''           | ''            | ''                  |
				| ''                                | 'Record type' | 'Period'               | 'Resources' | 'Dimensions' | ''            | ''                  |
				| ''                                | ''            | ''                     | 'Quantity'  | 'Store'      | 'Item key'    | 'Serial lot number' |
				| ''                                | 'Receipt'     | '$$DateProduction02$$' | '20'        | 'Store 05'   | 'Стандартный' | ''                  |
				| ''                                | 'Expense'     | '$$DateProduction02$$' | '19,6'      | 'Store 05'   | 'Стандартный' | ''                  |
			And I input "" text in "Register" field
			And I click "Generate report" button			
			Then "ResultTable" spreadsheet document is equal
				| '$$Production02$$'                                           | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| 'Document registrations records'                             | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| 'Register  "R7010 Detailing supplies"'                       | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | 'Period'               | 'Resources'             | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Dimensions'   | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | ''                     | 'Entry demand quantity' | 'Corrected demand quantity' | 'Needed produce quantity'        | 'Produced produce quantity' | 'Reserved produce quantity'          | 'Written off produce quantity' | 'Request procurement quantity' | 'Order transfer quantity' | 'Confirmed transfer quantity' | 'Order purchase quantity'            | 'Confirmed purchase quantity' | 'Company'      | 'Business unit'         | 'Store'    | 'Planning period' | 'Item key'    | '' |
				| ''                                                           | '$$DateProduction02$$' | ''                      | ''                          | ''                               | ''                          | ''                                   | '19,6'                         | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 05' | 'First month'     | 'Стандартный' | '' |
				| ''                                                           | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| 'Register  "R7020 Material planning"'                        | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | 'Period'               | 'Resources'             | 'Dimensions'                | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | ''                     | 'Quantity'              | 'Company'                   | 'Planning document'              | 'Business unit'             | 'Store'                              | 'Production'                   | 'Item key'                     | 'Planning type'           | 'Planning period'             | 'Bill of materials'                  | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction02$$' | '19,6'                  | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Стандартный'                  | 'Стандартный'                  | 'Produced'                | 'First month'                 | '01 Копыта на стремянки Класс 20х20' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| 'Register  "R7030 Production planning"'                      | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | 'Period'               | 'Resources'             | 'Dimensions'                | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | ''                     | 'Quantity'              | 'Company'                   | 'Planning document'              | 'Business unit'             | 'Store'                              | 'Item key'                     | 'Planning type'                | 'Planning period'         | 'Production type'             | 'Bill of materials'                  | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction02$$' | '20'                    | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Стандартный'                  | 'Produced'                     | 'First month'             | 'Product'                     | '01 Копыта на стремянки Класс 20х20' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| 'Register  "R7040 Manual materials corretion in production"' | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | 'Period'               | 'Resources'             | ''                          | 'Dimensions'                     | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | ''                     | 'Quantity'              | 'Quantity BOM'              | 'Company'                        | 'Business unit'             | 'Bill of materials'                  | 'Planning period'              | 'Item key BOM'                 | 'Item key'                | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction02$$' | '19,6'                  | '19,6'                      | 'Main Company'                   | 'Склад производства 05'     | '01 Копыта на стремянки Класс 20х20' | 'First month'                  | 'Стандартный'                  | 'Стандартный'             | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
			And I close all client application windows
	* Product
		Given I open hyperlink "e1cib/list/Document.Production"
		And I click the button named "FormCreate"
		* Filling in header info
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description' |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Select button of "Business unit" field
			And I go to line in "List" table
				| 'Description' |
				| 'Склад производства 05'     |
			And I select current line in "List" table
			And I click Select button of "Store production" field
			And I go to line in "List" table
				| 'Description'           |
				| 'Store 05' |
			And I select current line in "List" table			
			Then the form attribute named "ProductionPlanning" became equal to "$$ProductionPlanning01103110$$"			
		* Filling in production tab
			And I click Choice button of the field named "Item"
			And I go to line in "List" table
				| 'Description'                        |
				| 'Стремянка CLASS PLUS 6 ступенчатая' |
			And I select current line in "List" table
			Then the form attribute named "ItemKey" became equal to "Perilla"
			Then the form attribute named "BillOfMaterials" became equal to "Стремянка CLASS PLUS 6 ступенчатая"
			Then the form attribute named "Unit" became equal to "шт"
			And I input "10,000" text in the field named "Quantity"
			And I move to "Materials" tab			
			And "Materials" table contains lines
				| 'Item'                                    | 'Item key'    | 'Unit' | 'Q'      |
				| 'Заклепка 6х47 полупустотелая'            | 'Стандартный' | 'шт'   | '150,000' |
				| 'Скобы 3515 (Упаковочные)'                | 'Стандартный' | 'шт'   | '100,000' |
				| 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный' | 'шт'   | '50,000'  |
				| 'Катанка Ст3сп 6,5'                       | 'Стандартный' | 'кг'   | '20,000'  |
				| 'Краска порошковая серая 9006'            | 'Стандартный' | 'кг'   | '10,000'  |
				| 'труба электросварная круглая 10х1х5660'  | 'Стандартный' | 'шт'   | '20,000'  |
				| 'Копыта на стремянки Класс 20х20, черный' | 'Стандартный' | 'шт'   | '20,000'  |
				| 'Коврик для стремянок Класс, черный'      | 'Стандартный' | 'шт'   | '10,000'  |
				| 'Копыта на стремянки Класс 30х20, черный' | 'Стандартный' | 'шт'   | '20,000'  |
			Then the number of "Materials" table lines is "меньше или равно" "9"
			* Filling material type and writeoff store
				And I go to line in "Materials" table
					| '#' | '(BOM) Item'               | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                     | 'Item key'    | 'Q'       | 'Unit' |
					| '2' | 'Скобы 3515 (Упаковочные)' | 'Стандартный'    | '100,000' | 'шт'         | 'Скобы 3515 (Упаковочные)' | 'Стандартный' | '100,000' | 'шт'   |
				And I activate "Material type" field in "Materials" table				
				And I select "Material" exact value from "Material type" drop-down list in "Materials" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#' | '(BOM) Item'                   | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                         | 'Item key'    | 'Q'       | 'Unit' |
					| '1' | 'Заклепка 6х47 полупустотелая' | 'Стандартный'    | '150,000' | 'шт'         | 'Заклепка 6х47 полупустотелая' | 'Стандартный' | '150,000' | 'шт'   |
				And I select current line in "Materials" table
				And I select "Material" exact value from "Material type" drop-down list in "Materials" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#' | '(BOM) Item'                              | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                                    | 'Item key'    | 'Q'      | 'Unit' |
					| '3' | 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный'    | '50,000'  | 'шт'         | 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный' | '50,000' | 'шт'   |
				And I select current line in "Materials" table
				And I select "Material" exact value from "Material type" drop-down list in "Materials" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#' | '(BOM) Item'        | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'              | 'Item key'    | 'Q'      | 'Unit' |
					| '4' | 'Катанка Ст3сп 6,5' | 'Стандартный'    | '20,000'  | 'кг'         | 'Катанка Ст3сп 6,5' | 'Стандартный' | '20,000' | 'кг'   |
				And I select current line in "Materials" table
				And I select "Material" exact value from "Material type" drop-down list in "Materials" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#' | '(BOM) Item'                   | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                         | 'Item key'    | 'Q'      | 'Unit' |
					| '5' | 'Краска порошковая серая 9006' | 'Стандартный'    | '10,000'  | 'кг'         | 'Краска порошковая серая 9006' | 'Стандартный' | '10,000' | 'кг'   |
				And I select current line in "Materials" table
				And I select "Material" exact value from "Material type" drop-down list in "Materials" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#' | '(BOM) Item'                             | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                                   | 'Item key'    | 'Q'      | 'Unit' |
					| '6' | 'труба электросварная круглая 10х1х5660' | 'Стандартный'    | '20,000'  | 'шт'         | 'труба электросварная круглая 10х1х5660' | 'Стандартный' | '20,000' | 'шт'   |
				And I select current line in "Materials" table
				And I select "Material" exact value from "Material type" drop-down list in "Materials" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#' | '(BOM) Item'                              | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                                    | 'Item key'    | 'Q'      | 'Unit' |
					| '7' | 'Копыта на стремянки Класс 20х20, черный' | 'Стандартный'    | '20,000'  | 'шт'         | 'Копыта на стремянки Класс 20х20, черный' | 'Стандартный' | '20,000' | 'шт'   |
				And I select current line in "Materials" table
				And I select "Material" exact value from "Material type" drop-down list in "Materials" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#' | '(BOM) Item'                         | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                               | 'Item key'    | 'Q'      | 'Unit' |
					| '8' | 'Коврик для стремянок Класс, черный' | 'Стандартный'    | '10,000'  | 'шт'         | 'Коврик для стремянок Класс, черный' | 'Стандартный' | '10,000' | 'шт'   |
				And I select current line in "Materials" table
				And I select "Material" exact value from "Material type" drop-down list in "Materials" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#' | '(BOM) Item'                              | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                                    | 'Item key'    | 'Q'      | 'Unit' |
					| '9' | 'Копыта на стремянки Класс 30х20, черный' | 'Стандартный'    | '20,000'  | 'шт'         | 'Копыта на стремянки Класс 30х20, черный' | 'Стандартный' | '20,000' | 'шт'   |
				And I select current line in "Materials" table
				And I select "Material" exact value from "Material type" drop-down list in "Materials" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#' | '(BOM) Item'                   | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                         | 'Item key'    | 'Material type' | 'Q'       | 'Unit' |
					| '1' | 'Заклепка 6х47 полупустотелая' | 'Стандартный'    | '150,000' | 'шт'         | 'Заклепка 6х47 полупустотелая' | 'Стандартный' | 'Material'      | '150,000' | 'шт'   |
				And I activate "Writeoff store" field in "Materials" table
				And I select current line in "Materials" table
				And I click choice button of "Writeoff store" attribute in "Materials" table
				And I go to line in "List" table
					| 'Description' | 'Reference' |
					| 'Store 05'    | 'Store 05'  |
				And I select current line in "List" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#' | '(BOM) Item'               | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                     | 'Item key'    | 'Material type' | 'Q'       | 'Unit' |
					| '2' | 'Скобы 3515 (Упаковочные)' | 'Стандартный'    | '100,000' | 'шт'         | 'Скобы 3515 (Упаковочные)' | 'Стандартный' | 'Material'      | '100,000' | 'шт'   |
				And I select current line in "Materials" table
				And I click choice button of "Writeoff store" attribute in "Materials" table
				And I go to line in "List" table
					| 'Description' | 'Reference' |
					| 'Store 05'    | 'Store 05'  |
				And I select current line in "List" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#' | '(BOM) Item'                              | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                                    | 'Item key'    | 'Material type' | 'Q'      | 'Unit' |
					| '3' | 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный'    | '50,000'  | 'шт'         | 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный' | 'Material'      | '50,000' | 'шт'   |
				And I select current line in "Materials" table
				And I click choice button of "Writeoff store" attribute in "Materials" table
				Then "Stores" window is opened
				And I go to line in "List" table
					| 'Description' |
					| 'Store 05'    |
				And I select current line in "List" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#' | '(BOM) Item'        | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'              | 'Item key'    | 'Material type' | 'Q'      | 'Unit' |
					| '4' | 'Катанка Ст3сп 6,5' | 'Стандартный'    | '20,000'  | 'кг'         | 'Катанка Ст3сп 6,5' | 'Стандартный' | 'Material'      | '20,000' | 'кг'   |
				And I select current line in "Materials" table
				And I click choice button of "Writeoff store" attribute in "Materials" table
				Then "Stores" window is opened
				And I go to line in "List" table
					| 'Description' | 'Reference' |
					| 'Store 05'    | 'Store 05'  |
				And I select current line in "List" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#' | '(BOM) Item'                   | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                         | 'Item key'    | 'Material type' | 'Q'      | 'Unit' |
					| '5' | 'Краска порошковая серая 9006' | 'Стандартный'    | '10,000'  | 'кг'         | 'Краска порошковая серая 9006' | 'Стандартный' | 'Material'      | '10,000' | 'кг'   |
				And I select current line in "Materials" table
				And I click choice button of "Writeoff store" attribute in "Materials" table
				And I go to line in "List" table
					| 'Description' |
					| 'Store 05'    |
				And I select current line in "List" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#' | '(BOM) Item'                             | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                                   | 'Item key'    | 'Material type' | 'Q'      | 'Unit' |
					| '6' | 'труба электросварная круглая 10х1х5660' | 'Стандартный'    | '20,000'  | 'шт'         | 'труба электросварная круглая 10х1х5660' | 'Стандартный' | 'Material'      | '20,000' | 'шт'   |
				And I select current line in "Materials" table
				And I click choice button of "Writeoff store" attribute in "Materials" table
				Then "Stores" window is opened
				And I go to line in "List" table
					| 'Description' |
					| 'Store 05'    |
				And I select current line in "List" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#' | '(BOM) Item'                              | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                                    | 'Item key'    | 'Material type' | 'Q'      | 'Unit' |
					| '7' | 'Копыта на стремянки Класс 20х20, черный' | 'Стандартный'    | '20,000'  | 'шт'         | 'Копыта на стремянки Класс 20х20, черный' | 'Стандартный' | 'Material'      | '20,000' | 'шт'   |
				And I select current line in "Materials" table
				And I click choice button of "Writeoff store" attribute in "Materials" table
				Then "Stores" window is opened
				And I go to line in "List" table
					| 'Description' | 'Reference' |
					| 'Store 05'    | 'Store 05'  |
				And I select current line in "List" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#' | '(BOM) Item'                         | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                               | 'Item key'    | 'Material type' | 'Q'      | 'Unit' |
					| '8' | 'Коврик для стремянок Класс, черный' | 'Стандартный'    | '10,000'  | 'шт'         | 'Коврик для стремянок Класс, черный' | 'Стандартный' | 'Material'      | '10,000' | 'шт'   |
				And I select current line in "Materials" table
				And I click choice button of "Writeoff store" attribute in "Materials" table
				Then "Stores" window is opened
				And I go to line in "List" table
					| 'Description' |
					| 'Store 05'    |
				And I select current line in "List" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#' | '(BOM) Item'                              | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                                    | 'Item key'    | 'Material type' | 'Q'      | 'Unit' |
					| '9' | 'Копыта на стремянки Класс 30х20, черный' | 'Стандартный'    | '20,000'  | 'шт'         | 'Копыта на стремянки Класс 30х20, черный' | 'Стандартный' | 'Material'      | '20,000' | 'шт'   |
				And I select current line in "Materials" table
				And I click choice button of "Writeoff store" attribute in "Materials" table
				Then "Stores" window is opened
				And I go to line in "List" table
					| 'Description' |
					| 'Store 05'    |
				And I select current line in "List" table		
			And I click the button named "FormPost"
			And I delete "$$NumberProduction01$$" variable
			And I delete "$$Production01$$" variable
			And I delete "$$DateProduction01$$" variable
			And I save the value of "Number" field as "$$NumberProduction01$$"
			And I save the window as "$$Production01$$"
			And I save the value of the field named "Date" as "$$DateProduction01$$"			
		* Check movements
			And I click "Registrations report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$Production01$$'                                           | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| 'Document registrations records'                             | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| 'Register  "R7010 Detailing supplies"'                       | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | 'Period'               | 'Resources'             | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Dimensions'   | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | ''                     | 'Entry demand quantity' | 'Corrected demand quantity' | 'Needed produce quantity'        | 'Produced produce quantity' | 'Reserved produce quantity'          | 'Written off produce quantity' | 'Request procurement quantity' | 'Order transfer quantity' | 'Confirmed transfer quantity' | 'Order purchase quantity'            | 'Confirmed purchase quantity' | 'Company'      | 'Business unit'         | 'Store'    | 'Planning period' | 'Item key'    | '' |
				| ''                                                           | '$$DateProduction01$$' | ''                      | ''                          | ''                               | ''                          | ''                                   | '10'                           | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 05' | 'First month'     | 'Стандартный' | '' |
				| ''                                                           | '$$DateProduction01$$' | ''                      | ''                          | ''                               | ''                          | ''                                   | '10'                           | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 05' | 'First month'     | 'Стандартный' | '' |
				| ''                                                           | '$$DateProduction01$$' | ''                      | ''                          | ''                               | ''                          | ''                                   | '20'                           | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 05' | 'First month'     | 'Стандартный' | '' |
				| ''                                                           | '$$DateProduction01$$' | ''                      | ''                          | ''                               | ''                          | ''                                   | '20'                           | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 05' | 'First month'     | 'Стандартный' | '' |
				| ''                                                           | '$$DateProduction01$$' | ''                      | ''                          | ''                               | ''                          | ''                                   | '20'                           | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 05' | 'First month'     | 'Стандартный' | '' |
				| ''                                                           | '$$DateProduction01$$' | ''                      | ''                          | ''                               | ''                          | ''                                   | '20'                           | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 05' | 'First month'     | 'Стандартный' | '' |
				| ''                                                           | '$$DateProduction01$$' | ''                      | ''                          | ''                               | ''                          | ''                                   | '50'                           | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 05' | 'First month'     | 'Стандартный' | '' |
				| ''                                                           | '$$DateProduction01$$' | ''                      | ''                          | ''                               | ''                          | ''                                   | '100'                          | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 05' | 'First month'     | 'Стандартный' | '' |
				| ''                                                           | '$$DateProduction01$$' | ''                      | ''                          | ''                               | ''                          | ''                                   | '150'                          | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 05' | 'First month'     | 'Стандартный' | '' |
				| ''                                                           | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| 'Register  "R7020 Material planning"'                        | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | 'Period'               | 'Resources'             | 'Dimensions'                | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | ''                     | 'Quantity'              | 'Company'                   | 'Planning document'              | 'Business unit'             | 'Store'                              | 'Production'                   | 'Item key'                     | 'Planning type'           | 'Planning period'             | 'Bill of materials'                  | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '10'                    | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Стандартный'                  | 'Produced'                | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '10'                    | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Стандартный'                  | 'Produced'                | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '20'                    | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Стандартный'                  | 'Produced'                | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '20'                    | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Стандартный'                  | 'Produced'                | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '20'                    | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Стандартный'                  | 'Produced'                | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '20'                    | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Стандартный'                  | 'Produced'                | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '50'                    | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Стандартный'                  | 'Produced'                | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '100'                   | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Стандартный'                  | 'Produced'                | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '150'                   | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Стандартный'                  | 'Produced'                | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| 'Register  "R7030 Production planning"'                      | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | 'Period'               | 'Resources'             | 'Dimensions'                | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | ''                     | 'Quantity'              | 'Company'                   | 'Planning document'              | 'Business unit'             | 'Store'                              | 'Item key'                     | 'Planning type'                | 'Planning period'         | 'Production type'             | 'Bill of materials'                  | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '10'                    | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Produced'                     | 'First month'             | 'Product'                     | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| 'Register  "R7040 Manual materials corretion in production"' | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | 'Period'               | 'Resources'             | ''                          | 'Dimensions'                     | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | ''                     | 'Quantity'              | 'Quantity BOM'              | 'Company'                        | 'Business unit'             | 'Bill of materials'                  | 'Planning period'              | 'Item key BOM'                 | 'Item key'                | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '10'                    | '10'                        | 'Main Company'                   | 'Склад производства 05'     | 'Стремянка CLASS PLUS 6 ступенчатая' | 'First month'                  | 'Стандартный'                  | 'Стандартный'             | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '10'                    | '10'                        | 'Main Company'                   | 'Склад производства 05'     | 'Стремянка CLASS PLUS 6 ступенчатая' | 'First month'                  | 'Стандартный'                  | 'Стандартный'             | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '20'                    | '20'                        | 'Main Company'                   | 'Склад производства 05'     | 'Стремянка CLASS PLUS 6 ступенчатая' | 'First month'                  | 'Стандартный'                  | 'Стандартный'             | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '20'                    | '20'                        | 'Main Company'                   | 'Склад производства 05'     | 'Стремянка CLASS PLUS 6 ступенчатая' | 'First month'                  | 'Стандартный'                  | 'Стандартный'             | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '20'                    | '20'                        | 'Main Company'                   | 'Склад производства 05'     | 'Стремянка CLASS PLUS 6 ступенчатая' | 'First month'                  | 'Стандартный'                  | 'Стандартный'             | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '20'                    | '20'                        | 'Main Company'                   | 'Склад производства 05'     | 'Стремянка CLASS PLUS 6 ступенчатая' | 'First month'                  | 'Стандартный'                  | 'Стандартный'             | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '50'                    | '50'                        | 'Main Company'                   | 'Склад производства 05'     | 'Стремянка CLASS PLUS 6 ступенчатая' | 'First month'                  | 'Стандартный'                  | 'Стандартный'             | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '100'                   | '100'                       | 'Main Company'                   | 'Склад производства 05'     | 'Стремянка CLASS PLUS 6 ступенчатая' | 'First month'                  | 'Стандартный'                  | 'Стандартный'             | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '150'                   | '150'                       | 'Main Company'                   | 'Склад производства 05'     | 'Стремянка CLASS PLUS 6 ступенчатая' | 'First month'                  | 'Стандартный'                  | 'Стандартный'             | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
			And I select "R4011 Free stocks" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| 'Document registrations records' | ''            | ''                     | ''          | ''           | ''            |
				| 'Register  "R4011 Free stocks"'  | ''            | ''                     | ''          | ''           | ''            |
				| ''                               | 'Record type' | 'Period'               | 'Resources' | 'Dimensions' | ''            |
				| ''                               | ''            | ''                     | 'Quantity'  | 'Store'      | 'Item key'    |
				| ''                               | 'Receipt'     | '$$DateProduction01$$' | '10'        | 'Store 01'   | 'Perilla'     |
				| ''                               | 'Expense'     | '$$DateProduction01$$' | '10'        | 'Store 05'   | 'Стандартный' |
				| ''                               | 'Expense'     | '$$DateProduction01$$' | '10'        | 'Store 05'   | 'Стандартный' |
				| ''                               | 'Expense'     | '$$DateProduction01$$' | '20'        | 'Store 05'   | 'Стандартный' |
				| ''                               | 'Expense'     | '$$DateProduction01$$' | '20'        | 'Store 05'   | 'Стандартный' |
				| ''                               | 'Expense'     | '$$DateProduction01$$' | '20'        | 'Store 05'   | 'Стандартный' |
				| ''                               | 'Expense'     | '$$DateProduction01$$' | '20'        | 'Store 05'   | 'Стандартный' |
				| ''                               | 'Expense'     | '$$DateProduction01$$' | '50'        | 'Store 05'   | 'Стандартный' |
				| ''                               | 'Expense'     | '$$DateProduction01$$' | '100'       | 'Store 05'   | 'Стандартный' |
				| ''                               | 'Expense'     | '$$DateProduction01$$' | '150'       | 'Store 05'   | 'Стандартный' |
			And I select "R4010 Actual stocks" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| 'Register  "R4010 Actual stocks"' | ''            | ''                     | ''          | ''                      | ''            | ''                  |
				| ''                                | 'Record type' | 'Period'               | 'Resources' | 'Dimensions'            | ''            | ''                  |
				| ''                                | ''            | ''                     | 'Quantity'  | 'Store'                 | 'Item key'    | 'Serial lot number' |
				| ''                                | 'Receipt'     | '$$DateProduction01$$' | '10'        | 'Store 05' | 'Perilla'     | ''                  |
				| ''                                | 'Expense'     | '$$DateProduction01$$' | '10'        | 'Store 05' | 'Стандартный' | ''                  |
				| ''                                | 'Expense'     | '$$DateProduction01$$' | '10'        | 'Store 05' | 'Стандартный' | ''                  |
				| ''                                | 'Expense'     | '$$DateProduction01$$' | '20'        | 'Store 05' | 'Стандартный' | ''                  |
				| ''                                | 'Expense'     | '$$DateProduction01$$' | '20'        | 'Store 05' | 'Стандартный' | ''                  |
				| ''                                | 'Expense'     | '$$DateProduction01$$' | '20'        | 'Store 05' | 'Стандартный' | ''                  |
				| ''                                | 'Expense'     | '$$DateProduction01$$' | '20'        | 'Store 05' | 'Стандартный' | ''                  |
				| ''                                | 'Expense'     | '$$DateProduction01$$' | '50'        | 'Store 05' | 'Стандартный' | ''                  |
				| ''                                | 'Expense'     | '$$DateProduction01$$' | '100'       | 'Store 05' | 'Стандартный' | ''                  |
				| ''                                | 'Expense'     | '$$DateProduction01$$' | '150'       | 'Store 05' | 'Стандартный' | ''                  |
			And I close all client application windows



		

Scenario: _1036 check Production movements when unpost, re-post document
	* Check movements
			Given I open hyperlink "e1cib/list/Document.Production"
			And I go to line in "List" table
				| 'Number'                               |
				| '$$NumberProduction01$$' |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		* Check that there is no movement on the registers
			Given I open hyperlink "e1cib/list/AccumulationRegister.R7030T_ProductionPlanning"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$Production01$$' |
			Given I open hyperlink "e1cib/list/AccumulationRegister.R4011B_FreeStocks"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$Production01$$' |
			Given I open hyperlink "e1cib/list/AccumulationRegister.R7020T_MaterialPlanning"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$Production01$$' |
			Given I open hyperlink "e1cib/list/AccumulationRegister.R4010B_ActualStocks"
			And "List" table does not contain lines
				| 'Recorder'           |
				| '$$Production01$$' |
			And I close all client application windows
	* Re-posting the document and checking movements on the registers
		* Posting the document
			Given I open hyperlink "e1cib/list/Document.Production"
			And I go to line in "List" table
			| 'Number'                               |
			| '$$NumberProduction01$$' |
			And in the table "List" I click the button named "ListContextMenuPost"
		* Check movements
			And I click "Registrations report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$Production01$$'                                           | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| 'Document registrations records'                             | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| 'Register  "R7010 Detailing supplies"'                       | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | 'Period'               | 'Resources'             | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Dimensions'   | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | ''                     | 'Entry demand quantity' | 'Corrected demand quantity' | 'Needed produce quantity'        | 'Produced produce quantity' | 'Reserved produce quantity'          | 'Written off produce quantity' | 'Request procurement quantity' | 'Order transfer quantity' | 'Confirmed transfer quantity' | 'Order purchase quantity'            | 'Confirmed purchase quantity' | 'Company'      | 'Business unit'         | 'Store'    | 'Planning period' | 'Item key'    | '' |
				| ''                                                           | '$$DateProduction01$$' | ''                      | ''                          | ''                               | ''                          | ''                                   | '10'                           | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 05' | 'First month'     | 'Стандартный' | '' |
				| ''                                                           | '$$DateProduction01$$' | ''                      | ''                          | ''                               | ''                          | ''                                   | '10'                           | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 05' | 'First month'     | 'Стандартный' | '' |
				| ''                                                           | '$$DateProduction01$$' | ''                      | ''                          | ''                               | ''                          | ''                                   | '20'                           | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 05' | 'First month'     | 'Стандартный' | '' |
				| ''                                                           | '$$DateProduction01$$' | ''                      | ''                          | ''                               | ''                          | ''                                   | '20'                           | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 05' | 'First month'     | 'Стандартный' | '' |
				| ''                                                           | '$$DateProduction01$$' | ''                      | ''                          | ''                               | ''                          | ''                                   | '20'                           | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 05' | 'First month'     | 'Стандартный' | '' |
				| ''                                                           | '$$DateProduction01$$' | ''                      | ''                          | ''                               | ''                          | ''                                   | '20'                           | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 05' | 'First month'     | 'Стандартный' | '' |
				| ''                                                           | '$$DateProduction01$$' | ''                      | ''                          | ''                               | ''                          | ''                                   | '50'                           | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 05' | 'First month'     | 'Стандартный' | '' |
				| ''                                                           | '$$DateProduction01$$' | ''                      | ''                          | ''                               | ''                          | ''                                   | '100'                          | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 05' | 'First month'     | 'Стандартный' | '' |
				| ''                                                           | '$$DateProduction01$$' | ''                      | ''                          | ''                               | ''                          | ''                                   | '150'                          | ''                             | ''                        | ''                            | ''                                   | ''                            | 'Main Company' | 'Склад производства 05' | 'Store 05' | 'First month'     | 'Стандартный' | '' |
				| ''                                                           | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| 'Register  "R7020 Material planning"'                        | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | 'Period'               | 'Resources'             | 'Dimensions'                | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | ''                     | 'Quantity'              | 'Company'                   | 'Planning document'              | 'Business unit'             | 'Store'                              | 'Production'                   | 'Item key'                     | 'Planning type'           | 'Planning period'             | 'Bill of materials'                  | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '10'                    | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Стандартный'                  | 'Produced'                | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '10'                    | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Стандартный'                  | 'Produced'                | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '20'                    | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Стандартный'                  | 'Produced'                | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '20'                    | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Стандартный'                  | 'Produced'                | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '20'                    | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Стандартный'                  | 'Produced'                | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '20'                    | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Стандартный'                  | 'Produced'                | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '50'                    | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Стандартный'                  | 'Produced'                | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '100'                   | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Стандартный'                  | 'Produced'                | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '150'                   | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Стандартный'                  | 'Produced'                | 'First month'                 | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| 'Register  "R7030 Production planning"'                      | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | 'Period'               | 'Resources'             | 'Dimensions'                | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | ''                     | 'Quantity'              | 'Company'                   | 'Planning document'              | 'Business unit'             | 'Store'                              | 'Item key'                     | 'Planning type'                | 'Planning period'         | 'Production type'             | 'Bill of materials'                  | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '10'                    | 'Main Company'              | '$$ProductionPlanning01103110$$' | 'Склад производства 05'     | 'Store 05'                           | 'Perilla'                      | 'Produced'                     | 'First month'             | 'Product'                     | 'Стремянка CLASS PLUS 6 ступенчатая' | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| 'Register  "R7040 Manual materials corretion in production"' | ''                     | ''                      | ''                          | ''                               | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | 'Period'               | 'Resources'             | ''                          | 'Dimensions'                     | ''                          | ''                                   | ''                             | ''                             | ''                        | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | ''                     | 'Quantity'              | 'Quantity BOM'              | 'Company'                        | 'Business unit'             | 'Bill of materials'                  | 'Planning period'              | 'Item key BOM'                 | 'Item key'                | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '10'                    | '10'                        | 'Main Company'                   | 'Склад производства 05'     | 'Стремянка CLASS PLUS 6 ступенчатая' | 'First month'                  | 'Стандартный'                  | 'Стандартный'             | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '10'                    | '10'                        | 'Main Company'                   | 'Склад производства 05'     | 'Стремянка CLASS PLUS 6 ступенчатая' | 'First month'                  | 'Стандартный'                  | 'Стандартный'             | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '20'                    | '20'                        | 'Main Company'                   | 'Склад производства 05'     | 'Стремянка CLASS PLUS 6 ступенчатая' | 'First month'                  | 'Стандартный'                  | 'Стандартный'             | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '20'                    | '20'                        | 'Main Company'                   | 'Склад производства 05'     | 'Стремянка CLASS PLUS 6 ступенчатая' | 'First month'                  | 'Стандартный'                  | 'Стандартный'             | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '20'                    | '20'                        | 'Main Company'                   | 'Склад производства 05'     | 'Стремянка CLASS PLUS 6 ступенчатая' | 'First month'                  | 'Стандартный'                  | 'Стандартный'             | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '20'                    | '20'                        | 'Main Company'                   | 'Склад производства 05'     | 'Стремянка CLASS PLUS 6 ступенчатая' | 'First month'                  | 'Стандартный'                  | 'Стандартный'             | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '50'                    | '50'                        | 'Main Company'                   | 'Склад производства 05'     | 'Стремянка CLASS PLUS 6 ступенчатая' | 'First month'                  | 'Стандартный'                  | 'Стандартный'             | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '100'                   | '100'                       | 'Main Company'                   | 'Склад производства 05'     | 'Стремянка CLASS PLUS 6 ступенчатая' | 'First month'                  | 'Стандартный'                  | 'Стандартный'             | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
				| ''                                                           | '$$DateProduction01$$' | '150'                   | '150'                       | 'Main Company'                   | 'Склад производства 05'     | 'Стремянка CLASS PLUS 6 ступенчатая' | 'First month'                  | 'Стандартный'                  | 'Стандартный'             | ''                            | ''                                   | ''                            | ''             | ''                      | ''         | ''                | ''            | '' |
			And I select "R4011 Free stocks" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| 'Document registrations records'    | ''            | ''                     | ''          | ''                        | ''            |
				| 'Register  "R4011 Free stocks"'     | ''            | ''                     | ''          | ''                        | ''            |
				| ''                                  | 'Record type' | 'Period'               | 'Resources' | 'Dimensions'              | ''            |
				| ''                                  | ''            | ''                     | 'Quantity'  | 'Store'                   | 'Item key'    |
				| ''                                  | 'Receipt'     | '$$DateProduction01$$' | '10'        | 'Store 05'   | 'Perilla'     |
				| ''                                  | 'Expense'     | '$$DateProduction01$$' | '10'        | 'Store 05'   | 'Стандартный' | 
				| ''                                  | 'Expense'     | '$$DateProduction01$$' | '10'        | 'Store 05'   | 'Стандартный' | 
				| ''                                  | 'Expense'     | '$$DateProduction01$$' | '20'        | 'Store 05'   | 'Стандартный' |
				| ''                                  | 'Expense'     | '$$DateProduction01$$' | '20'        | 'Store 05'   | 'Стандартный' |
				| ''                                  | 'Expense'     | '$$DateProduction01$$' | '20'        | 'Store 05'   | 'Стандартный' |
				| ''                                  | 'Expense'     | '$$DateProduction01$$' | '20'        | 'Store 05'   | 'Стандартный' |
				| ''                                  | 'Expense'     | '$$DateProduction01$$' | '50'        | 'Store 05'   | 'Стандартный' |
				| ''                                  | 'Expense'     | '$$DateProduction01$$' | '100'       | 'Store 05'   | 'Стандартный' |
				| ''                                  | 'Expense'     | '$$DateProduction01$$' | '150'       | 'Store 05'   | 'Стандартный' |			
			And I select "R4010 Actual stocks" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| 'Register  "R4010 Actual stocks"' | ''            | ''                     | ''          | ''                      | ''            | ''                  |
				| ''                                | 'Record type' | 'Period'               | 'Resources' | 'Dimensions'            | ''            | ''                  |
				| ''                                | ''            | ''                     | 'Quantity'  | 'Store'                 | 'Item key'    | 'Serial lot number' |
				| ''                                | 'Receipt'     | '$$DateProduction01$$' | '10'        | 'Store 05' | 'Perilla'     | ''                  |
				| ''                                | 'Expense'     | '$$DateProduction01$$' | '10'        | 'Store 05' | 'Стандартный' | ''                  |
				| ''                                | 'Expense'     | '$$DateProduction01$$' | '10'        | 'Store 05' | 'Стандартный' | ''                  |
				| ''                                | 'Expense'     | '$$DateProduction01$$' | '20'        | 'Store 05' | 'Стандартный' | ''                  |
				| ''                                | 'Expense'     | '$$DateProduction01$$' | '20'        | 'Store 05' | 'Стандартный' | ''                  |
				| ''                                | 'Expense'     | '$$DateProduction01$$' | '20'        | 'Store 05' | 'Стандартный' | ''                  |
				| ''                                | 'Expense'     | '$$DateProduction01$$' | '20'        | 'Store 05' | 'Стандартный' | ''                  |
				| ''                                | 'Expense'     | '$$DateProduction01$$' | '50'        | 'Store 05' | 'Стандартный' | ''                  |
				| ''                                | 'Expense'     | '$$DateProduction01$$' | '100'       | 'Store 05' | 'Стандартный' | ''                  |
				| ''                                | 'Expense'     | '$$DateProduction01$$' | '150'       | 'Store 05' | 'Стандартный' | ''                  |
			And I close all client application windows
			



Scenario: _1037 create document Production based on production planning
	* Select ProductionPlanning
		Given I open hyperlink "e1cib/list/Document.ProductionPlanning"
		And I go to line in "List" table
			| 'Number'                               |
			| '$$NumberProductionPlanning01103110$$' |
	* Create document Production based on production planning
		And I click "Production" button
		And I go to line in "ProductionTable" table
			| 'Bill of materials'                  | 'Production'                                  | 'Q'      | 'Selected' | 'Unit' |
			| 'Стремянка CLASS PLUS 6 ступенчатая' | 'Стремянка CLASS PLUS 6 ступенчатая, Perilla' | '90,000'| 'No'       | 'шт'   |
		And I change "Selected" checkbox in "ProductionTable" table
		And I finish line editing in "ProductionTable" table
		And I click "Ok" button
	* Check filling 
		Then the form attribute named "DecorationClosingOrder" became equal to "This planning period is closed by:"
		Then the form attribute named "ProductionPlanningClosing" became equal to ""
		Then the form attribute named "DecorationGroupTitleCollapsedPicture" became equal to "Decoration group title collapsed picture"
		Then the form attribute named "DecorationGroupTitleCollapsedLabel" became equal to "Company: Main Company   Business unit: Склад производства 05   Store production: Store 01   "
		Then the form attribute named "DecorationGroupTitleUncollapsedPicture" became equal to "DecorationGroupTitleUncollapsedPicture"
		Then the form attribute named "DecorationGroupTitleUncollapsedLabel" became equal to "Company: Main Company   Business unit: Склад производства 05   Store production: Store 01   "
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "BusinessUnit" became equal to "Склад производства 05"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "PlanningPeriod" became equal to "First month"
		Then the form attribute named "Item" became equal to "Стремянка CLASS PLUS 6 ступенчатая"
		Then the form attribute named "ItemKey" became equal to "Perilla"
		Then the form attribute named "BillOfMaterials" became equal to "Стремянка CLASS PLUS 6 ступенчатая"
		Then the form attribute named "Unit" became equal to "шт"
		Then the form attribute named "StoreProduction" became equal to "Store 01"		
		And the editing text of form attribute named "Quantity" became equal to "90,000"
		And I move to "Materials" tab
		And "Materials" table contains lines
			| '(BOM) Item'                              | '(BOM) Item key' | '(BOM) Unit' | '(BOM) Q'   | 'Item'                                    | 'Item key'    | 'Unit' | 'Q'         | 'Material type' | 'Writeoff store'        |
			| 'Заклепка 6х47 полупустотелая'            | 'Стандартный'    | 'шт'         | '1 350,000' | 'Заклепка 6х47 полупустотелая'            | 'Стандартный' | 'шт'   | '1 350,000' | 'Material'      | 'Store 04' |
			| 'Катанка Ст3сп 6,5'                       | 'Стандартный'    | 'кг'         | '180,000'   | 'Катанка Ст3сп 6,5'                       | 'Стандартный' | 'кг'   | '180,000'   | 'Material'      | 'Store 07' |
			| 'Краска порошковая серая 9006'            | 'Стандартный'    | 'кг'         | '90,000'    | 'Краска порошковая серая 9006'            | 'Стандартный' | 'кг'   | '90,000'    | 'Material'      | 'Store 07' |
			| 'труба электросварная круглая 10х1х5660'  | 'Стандартный'    | 'шт'         | '180,000'   | 'труба электросварная круглая 10х1х5660'  | 'Стандартный' | 'шт'   | '180,000'   | 'Material'      | 'Store 07' |
			| 'Копыта на стремянки Класс 20х20, черный' | 'Стандартный'    | 'шт'         | '180,000'   | 'Копыта на стремянки Класс 20х20, черный' | 'Стандартный' | 'шт'   | '180,000'   | 'Semiproduct'   | 'Store 04' |
			| 'Копыта на стремянки Класс 30х20, черный' | 'Стандартный'    | 'шт'         | '180,000'   | 'Копыта на стремянки Класс 30х20, черный' | 'Стандартный' | 'шт'   | '180,000'   | 'Semiproduct'   | 'Store 04' |
			| 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный'    | 'шт'         | '450,000'   | 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный' | 'шт'   | '450,000'   | 'Material'      | 'Store 07' |
			| 'Коврик для стремянок Класс, черный'      | 'Стандартный'    | 'шт'         | '90,000'    | 'Коврик для стремянок Класс, черный'      | 'Стандартный' | 'шт'   | '90,000'    | 'Material'      | 'Store 07' |
			| 'Скобы 3515 (Упаковочные)'                | 'Стандартный'    | 'шт'         | '900,000'   | 'Скобы 3515 (Упаковочные)'                | 'Стандартный' | 'шт'   | '900,000'   | 'Material'      | 'Store 07' |
		Then the number of "Materials" table lines is "равно" "9"		
		Then the form attribute named "ProductionType" became equal to "Product"
		Then the form attribute named "Finished" became equal to "No"
		Then the form attribute named "Author" became equal to "CI"
	* Change Q and add new item
		And I activate field named "MaterialsQuantity" in "Materials" table
		And I go to line in "Materials" table
			| 'Item'                               | 'Item key'    | 'Q'      | 'Unit' |
			| 'Коврик для стремянок Класс, черный' | 'Стандартный' | '90,000' | 'шт'   |
		And I select current line in "Materials" table
		And I input "89,000" text in the field named "MaterialsQuantity" of "Materials" table
		And I finish line editing in "Materials" table
		And in the table "Materials" I click the button named "MaterialsAdd"
		And I click choice button of the attribute named "MaterialsItem" in "Materials" table
		And I go to line in "List" table
			| 'Code' | 'Description' | 'Reference'   |
			| '28'   | 'Упаковка 01' | 'Упаковка 01' |
		And I select current line in "List" table
		And I input "1,000" text in the field named "MaterialsQuantity" of "Materials" table
		And I select "Material" exact value from "Material type" drop-down list in "Materials" table
		And I activate "Writeoff store" field in "Materials" table
		And I click choice button of "Writeoff store" attribute in "Materials" table
		And I go to line in "List" table
			| 'Description' |
			| 'Store 04'    |
		And I select current line in "List" table				
		And I finish line editing in "Materials" table
		And "Materials" table contains lines
			| '(BOM) Item'                              | '(BOM) Item key' | '(BOM) Unit' | '(BOM) Q'   | 'Item'                                    | 'Item key'    | 'Unit' | 'Q'         | 'Material type' | 'Writeoff store' |
			| 'Заклепка 6х47 полупустотелая'            | 'Стандартный'    | 'шт'         | '1 350,000' | 'Заклепка 6х47 полупустотелая'            | 'Стандартный' | 'шт'   | '1 350,000' | 'Material'      | 'Store 04'       |
			| 'Катанка Ст3сп 6,5'                       | 'Стандартный'    | 'кг'         | '180,000'   | 'Катанка Ст3сп 6,5'                       | 'Стандартный' | 'кг'   | '180,000'   | 'Material'      | 'Store 07'       |
			| 'Краска порошковая серая 9006'            | 'Стандартный'    | 'кг'         | '90,000'    | 'Краска порошковая серая 9006'            | 'Стандартный' | 'кг'   | '90,000'    | 'Material'      | 'Store 07'       |
			| 'труба электросварная круглая 10х1х5660'  | 'Стандартный'    | 'шт'         | '180,000'   | 'труба электросварная круглая 10х1х5660'  | 'Стандартный' | 'шт'   | '180,000'   | 'Material'      | 'Store 07'       |
			| 'Копыта на стремянки Класс 20х20, черный' | 'Стандартный'    | 'шт'         | '180,000'   | 'Копыта на стремянки Класс 20х20, черный' | 'Стандартный' | 'шт'   | '180,000'   | 'Semiproduct'   | 'Store 04'       |
			| 'Копыта на стремянки Класс 30х20, черный' | 'Стандартный'    | 'шт'         | '180,000'   | 'Копыта на стремянки Класс 30х20, черный' | 'Стандартный' | 'шт'   | '180,000'   | 'Semiproduct'   | 'Store 04'       |
			| 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный'    | 'шт'         | '450,000'   | 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный' | 'шт'   | '450,000'   | 'Material'      | 'Store 07'       |
			| 'Коврик для стремянок Класс, черный'      | 'Стандартный'    | 'шт'         | '90,000'    | 'Коврик для стремянок Класс, черный'      | 'Стандартный' | 'шт'   | '89,000'    | 'Material'      | 'Store 07'       |
			| 'Скобы 3515 (Упаковочные)'                | 'Стандартный'    | 'шт'         | '900,000'   | 'Скобы 3515 (Упаковочные)'                | 'Стандартный' | 'шт'   | '900,000'   | 'Material'      | 'Store 07'       |
			| ''                                        | ''               | ''           | ''          | 'Упаковка 01'                             | '*'           | 'шт'   | '1,000'     | 'Material'      | 'Store 04'       |
		Then the number of "Materials" table lines is "равно" "10"		
	And I close all client application windows

Scenario: _1040 refilling document Production when change specification
	Given I open hyperlink "e1cib/list/Document.Production"
	And I click the button named "FormCreate"
	* Filling in header info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'     |
		And I select current line in "List" table
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description' |
			| 'Склад производства 05'     |
		And I select current line in "List" table
		Then the form attribute named "ProductionPlanning" became equal to "$$ProductionPlanning01103110$$"			
	* Filling in production tab
		And I click Choice button of the field named "Item"
		And I go to line in "List" table
			| 'Description'                        |
			| 'Стремянка CLASS PLUS 8' |
		And I select current line in "List" table
		Then the form attribute named "ItemKey" became equal to "Perilla"
	* Select Bill of materials
		And I click Select button of "Bill of materials" field
		And I go to line in "List" table
			| 'Description'                      |
			| 'Стремянка CLASS PLUS 8 (премиум)' |
		And I select current line in "List" table
		And I input "2,000" text in the field named "Quantity"
		Then the form attribute named "BusinessUnit" became equal to "Склад производства 05"		
	* Change material tab
		And I move to "Materials" tab
		And I activate field named "MaterialsQuantity" in "Materials" table
		And I select current line in "Materials" table
		And I input "21,000" text in the field named "MaterialsQuantity" of "Materials" table
		And I finish line editing in "Materials" table
	* Change Bill of materials
		And I move to "Production" tab
		And I click Select button of "Bill of materials" field
		And I go to line in "List" table
			| 'Description'                       |
			| 'Стремянка CLASS PLUS 8 (основная)' |
		And I select current line in "List" table
	* Check material tab
		And "Materials" table contains lines
			| '#' | '(BOM) Item'                              | '(BOM) Item key' | '(BOM) Unit' | '(BOM) Q' | 'Item'                                    | 'Item key'    | 'Unit' | 'Q'      |
			| '1' | 'Заклепка 6х47 полупустотелая'            | 'Стандартный'    | 'шт'         | '20,000'  | 'Заклепка 6х47 полупустотелая'            | 'Стандартный' | 'шт'   | '21,000' |
			| '2' | 'Скобы 3515 (Упаковочные)'                | 'Стандартный'    | 'шт'         | '20,000'  | 'Скобы 3515 (Упаковочные)'                | 'Стандартный' | 'шт'   | '20,000' |
			| '3' | 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный'    | 'шт'         | '10,000'  | 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный' | 'шт'   | '10,000' |
			| '4' | 'Катанка Ст3сп 6,5'                       | 'Стандартный'    | 'кг'         | '4,000'   | 'Катанка Ст3сп 6,5'                       | 'Стандартный' | 'кг'   | '4,000'  |
			| '5' | 'труба электросварная круглая 10х1х5660'  | 'Стандартный'    | 'шт'         | '4,000'   | 'труба электросварная круглая 10х1х5660'  | 'Стандартный' | 'шт'   | '4,000'  |
			| '6' | 'Копыта на стремянки Класс 20х20, черный' | 'Стандартный'    | 'шт'         | '4,000'   | 'Копыта на стремянки Класс 20х20, черный' | 'Стандартный' | 'шт'   | '4,000'  |
			| '7' | 'Копыта на стремянки Класс 30х20, черный' | 'Стандартный'    | 'шт'         | '4,000'   | 'Копыта на стремянки Класс 30х20, черный' | 'Стандартный' | 'шт'   | '4,000'  |
		And I go to line in "Materials" table
			| '#' | 'Item'                               | 'Item key'    | 'Q'     | 'Unit' |
			| '8' | 'Коврик для стремянок Класс, черный' | 'Стандартный' | '2,000' | 'шт'   |
		And in the table "Materials" I click "Delete" button
		And I click "Post" button
	* Change quantity and check material tab
		And I move to "Production" tab
		And I input "4,000" text in "Q" field
		And I move to "Materials" tab
		And "Materials" table became equal
			| '#' | '(BOM) Item'                              | '(BOM) Item key' | '(BOM) Unit' | '(BOM) Q' | 'Item'                                    | 'Item key'    | 'Unit' | 'Q'      |
			| '1' | 'Заклепка 6х47 полупустотелая'            | 'Стандартный'    | 'шт'         | '40,000'  | 'Заклепка 6х47 полупустотелая'            | 'Стандартный' | 'шт'   | '21,000' |
			| '2' | 'Скобы 3515 (Упаковочные)'                | 'Стандартный'    | 'шт'         | '40,000'  | 'Скобы 3515 (Упаковочные)'                | 'Стандартный' | 'шт'   | '40,000' |
			| '3' | 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный'    | 'шт'         | '20,000'  | 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный' | 'шт'   | '20,000' |
			| '4' | 'Катанка Ст3сп 6,5'                       | 'Стандартный'    | 'кг'         | '8,000'   | 'Катанка Ст3сп 6,5'                       | 'Стандартный' | 'кг'   | '8,000'  |
			| '5' | 'труба электросварная круглая 10х1х5660'  | 'Стандартный'    | 'шт'         | '8,000'   | 'труба электросварная круглая 10х1х5660'  | 'Стандартный' | 'шт'   | '8,000'  |
			| '6' | 'Копыта на стремянки Класс 20х20, черный' | 'Стандартный'    | 'шт'         | '8,000'   | 'Копыта на стремянки Класс 20х20, черный' | 'Стандартный' | 'шт'   | '8,000'  |
			| '7' | 'Копыта на стремянки Класс 30х20, черный' | 'Стандартный'    | 'шт'         | '8,000'   | 'Копыта на стремянки Класс 30х20, черный' | 'Стандартный' | 'шт'   | '8,000'  |
		* Filling material type and wtiteoff store
			And I activate "Material type" field in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                   | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                         | 'Item key'    | 'Q'      | 'Unit' |
				| 'Заклепка 6х47 полупустотелая' | 'Стандартный'    | '40,000'  | 'шт'         | 'Заклепка 6х47 полупустотелая' | 'Стандартный' | '21,000' | 'шт'   |
			And I select current line in "Materials" table
			And I select "Material" exact value from "Material type" drop-down list in "Materials" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'               | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                     | 'Item key'    | 'Q'      | 'Unit' |
				| 'Скобы 3515 (Упаковочные)' | 'Стандартный'    | '40,000'  | 'шт'         | 'Скобы 3515 (Упаковочные)' | 'Стандартный' | '40,000' | 'шт'   |
			And I select current line in "Materials" table
			And I select "Material" exact value from "Material type" drop-down list in "Materials" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                              | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                                    | 'Item key'    | 'Q'      | 'Unit' |
				| 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный'    | '20,000'  | 'шт'         | 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный' | '20,000' | 'шт'   |
			And I select current line in "Materials" table
			And I select "Material" exact value from "Material type" drop-down list in "Materials" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'        | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'              | 'Item key'    | 'Q'     | 'Unit' |
				| 'Катанка Ст3сп 6,5' | 'Стандартный'    | '8,000'   | 'кг'         | 'Катанка Ст3сп 6,5' | 'Стандартный' | '8,000' | 'кг'   |
			And I select current line in "Materials" table
			And I select "Material" exact value from "Material type" drop-down list in "Materials" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                             | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                                   | 'Item key'    | 'Q'     | 'Unit' |
				| 'труба электросварная круглая 10х1х5660' | 'Стандартный'    | '8,000'   | 'шт'         | 'труба электросварная круглая 10х1х5660' | 'Стандартный' | '8,000' | 'шт'   |
			And I select current line in "Materials" table
			And I select "Material" exact value from "Material type" drop-down list in "Materials" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                              | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                                    | 'Item key'    | 'Q'     | 'Unit' |
				| 'Копыта на стремянки Класс 20х20, черный' | 'Стандартный'    | '8,000'   | 'шт'         | 'Копыта на стремянки Класс 20х20, черный' | 'Стандартный' | '8,000' | 'шт'   |
			And I select current line in "Materials" table
			And I select "Semiproduct" exact value from "Material type" drop-down list in "Materials" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                              | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                                    | 'Item key'    | 'Q'     | 'Unit' |
				| 'Копыта на стремянки Класс 30х20, черный' | 'Стандартный'    | '8,000'   | 'шт'         | 'Копыта на стремянки Класс 30х20, черный' | 'Стандартный' | '8,000' | 'шт'   |
			And I select current line in "Materials" table
			And I select "Semiproduct" exact value from "Material type" drop-down list in "Materials" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                   | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                         | 'Item key'    | 'Material type' | 'Q'      | 'Unit' |
				| 'Заклепка 6х47 полупустотелая' | 'Стандартный'    | '40,000'  | 'шт'         | 'Заклепка 6х47 полупустотелая' | 'Стандартный' | 'Material'      | '21,000' | 'шт'   |
			And I activate "Writeoff store" field in "Materials" table
			And I select current line in "Materials" table
			And I click choice button of "Writeoff store" attribute in "Materials" table
			And I go to line in "List" table
				| 'Description' | 'Reference' |
				| 'Store 05'    | 'Store 05'  |
			And I select current line in "List" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'               | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                     | 'Item key'    | 'Material type' | 'Q'      | 'Unit' |
				| 'Скобы 3515 (Упаковочные)' | 'Стандартный'    | '40,000'  | 'шт'         | 'Скобы 3515 (Упаковочные)' | 'Стандартный' | 'Material'      | '40,000' | 'шт'   |
			And I select current line in "Materials" table
			And I click choice button of "Writeoff store" attribute in "Materials" table
			And I go to line in "List" table
				| 'Description' | 'Reference' |
				| 'Store 05'    | 'Store 05'  |
			And I select current line in "List" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                              | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                                    | 'Item key'    | 'Material type' | 'Q'      | 'Unit' |
				| 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный'    | '20,000'  | 'шт'         | 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный' | 'Material'      | '20,000' | 'шт'   |
			And I select current line in "Materials" table
			And I click choice button of "Writeoff store" attribute in "Materials" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Store 05' |
			And I select current line in "List" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'        | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'              | 'Item key'    | 'Material type' | 'Q'     | 'Unit' |
				| 'Катанка Ст3сп 6,5' | 'Стандартный'    | '8,000'   | 'кг'         | 'Катанка Ст3сп 6,5' | 'Стандартный' | 'Material'      | '8,000' | 'кг'   |
			And I select current line in "Materials" table
			And I click choice button of "Writeoff store" attribute in "Materials" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Store 05' |
			And I select current line in "List" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                             | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                                   | 'Item key'    | 'Material type' | 'Q'     | 'Unit' |
				| 'труба электросварная круглая 10х1х5660' | 'Стандартный'    | '8,000'   | 'шт'         | 'труба электросварная круглая 10х1х5660' | 'Стандартный' | 'Material'      | '8,000' | 'шт'   |
			And I select current line in "Materials" table
			And I click choice button of "Writeoff store" attribute in "Materials" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Store 05' |
			And I select current line in "List" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                              | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                                    | 'Item key'    | 'Material type' | 'Q'     | 'Unit' |
				| 'Копыта на стремянки Класс 20х20, черный' | 'Стандартный'    | '8,000'   | 'шт'         | 'Копыта на стремянки Класс 20х20, черный' | 'Стандартный' | 'Semiproduct'   | '8,000' | 'шт'   |
			And I select current line in "Materials" table
			And I click choice button of "Writeoff store" attribute in "Materials" table
			And I go to line in "List" table
				| 'Description' |
				| 'Store 04'    |
			And I select current line in "List" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                              | '(BOM) Item key' | '(BOM) Q' | '(BOM) Unit' | 'Item'                                    | 'Item key'    | 'Material type' | 'Q'     | 'Unit' |
				| 'Копыта на стремянки Класс 30х20, черный' | 'Стандартный'    | '8,000'   | 'шт'         | 'Копыта на стремянки Класс 30х20, черный' | 'Стандартный' | 'Semiproduct'   | '8,000' | 'шт'   |
			And I select current line in "Materials" table
			And I click choice button of "Writeoff store" attribute in "Materials" table
			And I go to line in "List" table
				| 'Description' |
				| 'Store 04'    |
			And I select current line in "List" table
			And I finish line editing in "Materials" table	
			And I move to "Production" tab
			And I click Select button of "Store production" field
			And I go to line in "List" table
				| 'Description'  |
				| 'Store 01' |
			And I select current line in "List" table				
		And I click "Post" button
		And I delete "$$DateProduction1040$$" variable
		And I delete "$$Production1040$$" variable
		And I save the value of the field named "Date" as "$$DateProduction1040$$"
		And I save the window as "$$Production1040$$"
	* Check movements by register (MF) Manual materials corretion in production
		And I click "Registrations report" button
		And I select "R7040 Manual materials corretion in production" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$Production1040$$'                                         | ''                       | ''          | ''             | ''             | ''                      | ''                                  | ''                | ''             | ''            |
			| 'Document registrations records'                             | ''                       | ''          | ''             | ''             | ''                      | ''                                  | ''                | ''             | ''            |
			| 'Register  "R7040 Manual materials corretion in production"' | ''                       | ''          | ''             | ''             | ''                      | ''                                  | ''                | ''             | ''            |
			| ''                                                           | 'Period'                 | 'Resources' | ''             | 'Dimensions'   | ''                      | ''                                  | ''                | ''             | ''            |
			| ''                                                           | ''                       | 'Quantity'  | 'Quantity BOM' | 'Company'      | 'Business unit'         | 'Bill of materials'                 | 'Planning period' | 'Item key BOM' | 'Item key'    |
			| ''                                                           | '$$DateProduction1040$$' | '8'         | '8'            | 'Main Company' | 'Склад производства 05' | 'Стремянка CLASS PLUS 8 (основная)' | 'First month'     | 'Стандартный'  | 'Стандартный' |
			| ''                                                           | '$$DateProduction1040$$' | '8'         | '8'            | 'Main Company' | 'Склад производства 05' | 'Стремянка CLASS PLUS 8 (основная)' | 'First month'     | 'Стандартный'  | 'Стандартный' |
			| ''                                                           | '$$DateProduction1040$$' | '8'         | '8'            | 'Main Company' | 'Склад производства 05' | 'Стремянка CLASS PLUS 8 (основная)' | 'First month'     | 'Стандартный'  | 'Стандартный' |
			| ''                                                           | '$$DateProduction1040$$' | '8'         | '8'            | 'Main Company' | 'Склад производства 05' | 'Стремянка CLASS PLUS 8 (основная)' | 'First month'     | 'Стандартный'  | 'Стандартный' |
			| ''                                                           | '$$DateProduction1040$$' | '20'        | '20'           | 'Main Company' | 'Склад производства 05' | 'Стремянка CLASS PLUS 8 (основная)' | 'First month'     | 'Стандартный'  | 'Стандартный' |
			| ''                                                           | '$$DateProduction1040$$' | '21'        | '40'           | 'Main Company' | 'Склад производства 05' | 'Стремянка CLASS PLUS 8 (основная)' | 'First month'     | 'Стандартный'  | 'Стандартный' |
			| ''                                                           | '$$DateProduction1040$$' | '40'        | '40'           | 'Main Company' | 'Склад производства 05' | 'Стремянка CLASS PLUS 8 (основная)' | 'First month'     | 'Стандартный'  | 'Стандартный' |
		And I close all client application windows
