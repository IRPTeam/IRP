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
	When change interface localization code for CI
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	When Create catalog AddAttributeAndPropertySets objects (MF)
	When Create catalog AddAttributeAndPropertyValues objects (MF)
	When Create catalog ItemTypes objects (MF)
	When Create catalog Items objects (MF)
	When Create catalog Units objects (MF)
	When Create catalog Units objects
	When Create catalog ItemKeys objects (MF)
	When Create chart of characteristic types AddAttributeAndProperty objects (MF)
	When Create catalog Stores objects
	When Create catalog Companies objects (Main company)
	When Create catalog Countries objects
	When Create chart of characteristic types CurrencyMovementType objects
	When Create catalog Currencies objects
	When Create catalog BusinessUnits objects (MF)
	When Create catalog Countries objects
	When Create catalog IntegrationSettings objects
	When Create information register CurrencyRates records
	When Create catalog MFBillOfMaterials objects


Scenario: _1005 create Bill of materials for semiproduct
	And In the command interface I select "Manufacturing" "Bill of materials"
	* Bill of materials for semiproduct
		* Копыта на стремянки Класс 20х20, черный (Test 1)
			And I click the button named "FormCreate"
			And I input "01 Копыта на стремянки Класс 20х20 (Test 1)" text in "RU" field
			And I click Choice button of the field named "Item"
			And I go to line in "List" table
				| 'Description'                                 |
				| 'Копыта на стремянки Класс 20х20, черный'     |
			And I select current line in "List" table
			And I click Choice button of the field named "ItemKey"
			And I close "Item keys" window		
			Then the form attribute named "ItemKey" became equal to "Копыта на стремянки Класс 20х20, черный"
			Then the form attribute named "Unit" became equal to "pcs"
			Then the form attribute named "Quantity" became equal to "1,000"
			And in the table "Content" I click the button named "ContentAdd"
			And I click choice button of the attribute named "ContentItem" in "Content" table
			And I go to line in "List" table
				| 'Description'     |
				| 'ПВД 158'         |
			And I select current line in "List" table
			And I activate field named "ContentQuantity" in "Content" table
			And I select current line in "Content" table
			And I input "0,980" text in the field named "ContentQuantity" of "Content" table
			And I finish line editing in "Content" table
			And "Content" table became equal
				| '#'    | 'Item'       | 'Item key'    | 'Unit'    | 'Quantity'    | 'Bill of materials'     |
				| '1'    | 'ПВД 158'    | 'ПВД 158'     | 'кг'      | '0,980'       | ''                      |
			And I click Select button of "Business unit" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Цех 07'          |
			And I select current line in "List" table		
			And I click "Save and close" button
		* Creation check
			And "List" table contains lines
				| 'Description'                                    | 'Item'                                       | 'Item key'                                    |
				| '01 Копыта на стремянки Класс 20х20 (Test 1)'    | 'Копыта на стремянки Класс 20х20, черный'    | 'Копыта на стремянки Класс 20х20, черный'     |
		And I close all client application windows
		

Scenario: _1006 create Bill of materials for product
		And I close all client application windows
		And In the command interface I select "Manufacturing" "Bill of materials"
		* Стремянка номер 5 ступенчатая (Test 2)
			And I click the button named "FormCreate"
			And I input "Стремянка номер 5 ступенчатая (Test 2)" text in "RU" field
			And I click Choice button of the field named "Item"
			And I go to line in "List" table
				| 'Description'                       |
				| 'Стремянка номер 5 ступенчатая'     |
			And I select current line in "List" table
			And I click Choice button of the field named "ItemKey"
			And I close "Item keys" window
			Then the form attribute named "ItemKey" became equal to "Стремянка номер 5 ступенчатая"
			Then the form attribute named "Unit" became equal to "pcs"
			Then the form attribute named "Quantity" became equal to "1,000"
			And in the table "Content" I click the button named "ContentAdd"
			And I click choice button of the attribute named "ContentItem" in "Content" table
			And I go to line in "List" table
				| 'Description'                      |
				| 'Заклепка 6х47 полупустотелая'     |
			And I select current line in "List" table
			And I activate field named "ContentQuantity" in "Content" table
			And I select current line in "Content" table
			And I input "15,000" text in the field named "ContentQuantity" of "Content" table
			And I finish line editing in "Content" table
			And in the table "Content" I click the button named "ContentAdd"
			And I click choice button of the attribute named "ContentItem" in "Content" table
			And I go to line in "List" table
				| 'Description'                  |
				| 'Скобы 3515 (Упаковочные)'     |
			And I select current line in "List" table
			And I activate field named "ContentQuantity" in "Content" table
			And I select current line in "Content" table
			And I input "10,000" text in the field named "ContentQuantity" of "Content" table
			And I finish line editing in "Content" table
			And in the table "Content" I click the button named "ContentAdd"
			And I click choice button of the attribute named "ContentItem" in "Content" table
			And I go to line in "List" table
				| 'Description'                                 |
				| 'Втулка на стремянки Класс 10 мм, черный'     |
			And I select current line in "List" table
			And I activate field named "ContentQuantity" in "Content" table
			And I select current line in "Content" table
			And I input "5,000" text in the field named "ContentQuantity" of "Content" table
			And I finish line editing in "Content" table
			And in the table "Content" I click the button named "ContentAdd"
			And I click choice button of the attribute named "ContentItem" in "Content" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Катанка Ст3сп 6,5'     |
			And I select current line in "List" table
			And I activate field named "ContentQuantity" in "Content" table
			And I select current line in "Content" table
			And I input "2,000" text in the field named "ContentQuantity" of "Content" table
			And I finish line editing in "Content" table
			And in the table "Content" I click the button named "ContentAdd"
			And I click choice button of the attribute named "ContentItem" in "Content" table
			And I go to line in "List" table
				| 'Description'                      |
				| 'Краска порошковая серая 9006'     |
			And I select current line in "List" table
			And I activate field named "ContentQuantity" in "Content" table
			And I select current line in "Content" table
			And I input "1,000" text in the field named "ContentQuantity" of "Content" table
			And I finish line editing in "Content" table
			And in the table "Content" I click the button named "ContentAdd"
			And I click choice button of the attribute named "ContentItem" in "Content" table
			And I go to line in "List" table
				| 'Description'                                |
				| 'труба электросварная круглая 10х1х5660'     |
			And I select current line in "List" table
			And I activate field named "ContentQuantity" in "Content" table
			And I select current line in "Content" table
			And I input "2,000" text in the field named "ContentQuantity" of "Content" table
			And I finish line editing in "Content" table
			And in the table "Content" I click the button named "ContentAdd"
			And I click choice button of the attribute named "ContentItem" in "Content" table
			And I go to line in "List" table
				| 'Description'                                 |
				| 'Копыта на стремянки Класс 20х20, черный'     |
			And I select current line in "List" table
			And I activate field named "ContentQuantity" in "Content" table
			And I select current line in "Content" table
			And I input "2,000" text in the field named "ContentQuantity" of "Content" table
			And I activate "Bill of materials" field in "Content" table
			And I click choice button of "Bill of materials" attribute in "Content" table
			And I go to line in "List" table
				| 'Description'                           | 'Item'                                       | 'Item key'                                    |
				| '01 Копыта на стремянки Класс 20х20'    | 'Копыта на стремянки Класс 20х20, черный'    | 'Копыта на стремянки Класс 20х20, черный'     |
			And I select current line in "List" table	
			And I finish line editing in "Content" table
			And "Content" table became equal
				| '#'    | 'Item'                                       | 'Item key'                                   | 'Unit'    | 'Quantity'    | 'Bill of materials'                      |
				| '1'    | 'Заклепка 6х47 полупустотелая'               | 'Заклепка 6х47 полупустотелая'               | 'pcs'     | '15,000'      | ''                                       |
				| '2'    | 'Скобы 3515 (Упаковочные)'                   | 'Скобы 3515 (Упаковочные)'                   | 'pcs'     | '10,000'      | ''                                       |
				| '3'    | 'Втулка на стремянки Класс 10 мм, черный'    | 'Втулка на стремянки Класс 10 мм, черный'    | 'pcs'     | '5,000'       | ''                                       |
				| '4'    | 'Катанка Ст3сп 6,5'                          | 'Катанка Ст3сп 6,5'                          | 'кг'      | '2,000'       | ''                                       |
				| '5'    | 'Краска порошковая серая 9006'               | 'Краска порошковая серая 9006'               | 'кг'      | '1,000'       | ''                                       |
				| '6'    | 'труба электросварная круглая 10х1х5660'     | 'труба электросварная круглая 10х1х5660'     | 'pcs'     | '2,000'       | ''                                       |
				| '7'    | 'Копыта на стремянки Класс 20х20, черный'    | 'Копыта на стремянки Класс 20х20, черный'    | 'pcs'     | '2,000'       | '01 Копыта на стремянки Класс 20х20'     |
			And I click Select button of "Business unit" field
			And I go to line in "List" table
				| 'Description'               |
				| 'Склад производства 05'     |
			And I select current line in "List" table
			Then the form attribute named "BusinessUnitReleaseStore" became equal to "Store 01"		
			Then the form attribute named "BusinessUnitSemiproductStore" became equal to "Store 04"
			Then the form attribute named "BusinessUnitMaterialStore" became equal to "Store 07"				
			And I click "Save and close" button		
	* Creation check
		And "List" table contains lines
			| 'Description'                              | 'Item'                            | 'Item key'                         |
			| 'Стремянка номер 5 ступенчатая (Test 2)'   | 'Стремянка номер 5 ступенчатая'   | 'Стремянка номер 5 ступенчатая'    |
		And I close all client application windows
		
Scenario: _1010 create document Production planning
	And In the command interface I select "Manufacturing" "Production plannings"
	* Production planning First month
		And I click the button named "FormCreate"
		* Filling in header info
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Select button of "Business unit" field
			And I go to line in "List" table
				| 'Description'               |
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
				| 'Business unit'             |
				| 'Склад производства 05'     |
			And I click "Save and close" button
			And I click the button named "FormChoose"
			Then the form attribute named "PlanningPeriod" became equal to "First month"
			Then the form attribute named "PlanningPeriodBeginDate" became equal to "$$StartDateFirstMonth$$"
			Then the form attribute named "PlanningPeriodEndDate" became equal to "$$EndDateFirstMonth$$"
			And I move to "Other" tab
			And I click Choice button of the field named "Branch"
			And I go to line in "List" table
				| 'Description' |
				| 'Цех 07'      |
			And I select current line in "List" table
		* Filling in item tab
			And in the table "Productions" I click the button named "ProductionsAdd"
			And I click choice button of "Item" attribute in "Productions" table
			Then "Items" window is opened
			And I go to line in "List" table
				| 'Description'                       |
				| 'Стремянка номер 6 ступенчатая'     |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate "Q" field in "Productions" table
			And I input "100,000" text in "Q" field of "Productions" table
			And I finish line editing in "Productions" table
			And in the table "Productions" I click the button named "ProductionsAdd"
			And I click choice button of "Item" attribute in "Productions" table
			And I go to line in "List" table
				| 'Description'                       |
				| 'Стремянка номер 5 ступенчатая'     |
			And I select current line in "List" table
			And I activate "Q" field in "Productions" table
			And I input "250,000" text in "Q" field of "Productions" table
			And I click choice button of "Bill of materials" attribute in "Productions" table
			And I go to line in "List" table
				| 'Description'                      | 'Item'                             | 'Item key'                          |
				| 'Стремянка номер 5 ступенчатая'    | 'Стремянка номер 5 ступенчатая'    | 'Стремянка номер 5 ступенчатая'     |
			And I select current line in "List" table		
			And I finish line editing in "Productions" table
			And "Productions" table contains lines
				| 'Item'                             | 'Item key'                         | 'Unit'    | 'Q'          | 'Bill of materials'                 |
				| 'Стремянка номер 6 ступенчатая'    | 'Стремянка номер 6 ступенчатая'    | 'pcs'     | '100,000'    | 'Стремянка номер 6 ступенчатая'     |
				| 'Стремянка номер 5 ступенчатая'    | 'Стремянка номер 5 ступенчатая'    | 'pcs'     | '250,000'    | 'Стремянка номер 5 ступенчатая'     |
			* Change production store and write off store
				And in the table "Productions" I click "Edit stores" button
				And I expand current line in "ProductionTree" table
				And I expand a line in "ProductionTree" table
					| 'Item'                                                                                 | 'Quantity'     | 'Surplus store'     | 'Unit'     | 'Writeoff store'      |
					| 'Копыта на стремянки Класс 20х20, черный, Копыта на стремянки Класс 20х20, черный'     | '200,000'      | 'Store 01'          | 'pcs'      | 'Store 04'            |
				And I expand a line in "ProductionTree" table
					| 'Item'                                                                                 | 'Quantity'     | 'Surplus store'     | 'Unit'     | 'Writeoff store'      |
					| 'Копыта на стремянки Класс 30х20, черный, Копыта на стремянки Класс 30х20, черный'     | '200,000'      | 'Store 01'          | 'pcs'      | 'Store 04'            |
				And I activate "Surplus store" field in "ProductionTree" table
				And I select current line in "ProductionTree" table
				And I click choice button of "Surplus store" attribute in "ProductionTree" table
				And I go to line in "List" table
					| 'Description'      |
					| 'Store 01'         |
				And I select current line in "List" table
				And I finish line editing in "ProductionTree" table
				And I go to line in "ProductionTree" table
					| 'Item'                                                           | 'Quantity'      | 'Unit'     | 'Writeoff store'      |
					| 'Заклепка 6х47 полупустотелая, Заклепка 6х47 полупустотелая'     | '1 500,000'     | 'pcs'      | 'Store 07'            |
				And I activate "Writeoff store" field in "ProductionTree" table
				And I select current line in "ProductionTree" table
				And I click choice button of "Writeoff store" attribute in "ProductionTree" table
				Then "Stores" window is opened
				And I go to line in "List" table
					| 'Description'      |
					| 'Store 04'         |
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
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Select button of "Business unit" field
			And I go to line in "List" table
				| 'Description'               |
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
			Then the form attribute named "PlanningPeriodBeginDate" became equal to "$$StartDateSecondMonth$$"
			And the editing text of form attribute named "PlanningPeriodEndDate" became equal to "$$EndDateSecondMonth$$"
		* Filling in item tab
			And in the table "Productions" I click the button named "ProductionsAdd"
			And I click choice button of "Item" attribute in "Productions" table
			Then "Items" window is opened
			And I go to line in "List" table
				| 'Description'                       |
				| 'Стремянка номер 6 ступенчатая'     |
			And I activate "Description" field in "List" table
			And I select current line in "List" table
			And I activate "Q" field in "Productions" table
			And I input "122,000" text in "Q" field of "Productions" table
			And I finish line editing in "Productions" table
			And in the table "Productions" I click the button named "ProductionsAdd"
			And I click choice button of "Item" attribute in "Productions" table
			And I go to line in "List" table
				| 'Description'                       |
				| 'Стремянка номер 5 ступенчатая'     |
			And I select current line in "List" table
			And I activate "Q" field in "Productions" table
			And I input "233,000" text in "Q" field of "Productions" table
			And I click choice button of "Bill of materials" attribute in "Productions" table
			And I go to line in "List" table
				| 'Description'                      | 'Item'                             | 'Item key'                          |
				| 'Стремянка номер 5 ступенчатая'    | 'Стремянка номер 5 ступенчатая'    | 'Стремянка номер 5 ступенчатая'     |
			And I select current line in "List" table
			And I finish line editing in "Productions" table
			And "Productions" table contains lines
				| 'Item'                             | 'Item key'                         | 'Unit'    | 'Q'          | 'Bill of materials'                 |
				| 'Стремянка номер 6 ступенчатая'    | 'Стремянка номер 6 ступенчатая'    | 'pcs'     | '122,000'    | 'Стремянка номер 6 ступенчатая'     |
				| 'Стремянка номер 5 ступенчатая'    | 'Стремянка номер 5 ступенчатая'    | 'pcs'     | '233,000'    | 'Стремянка номер 5 ступенчатая'     |
			* Check filling stores
				And in the table "Productions" I click "Edit stores" button
				And I expand current line in "ProductionTree" table
				And I expand a line in "ProductionTree" table
					| 'Item'                                                                                 | 'Quantity'     | 'Surplus store'     | 'Unit'     | 'Writeoff store'      |
					| 'Копыта на стремянки Класс 20х20, черный, Копыта на стремянки Класс 20х20, черный'     | '244,000'      | 'Store 01'          | 'pcs'      | 'Store 04'            |
				And I expand a line in "ProductionTree" table
					| 'Item'                                                                                 | 'Quantity'     | 'Surplus store'     | 'Unit'     | 'Writeoff store'      |
					| 'Копыта на стремянки Класс 30х20, черный, Копыта на стремянки Класс 30х20, черный'     | '244,000'      | 'Store 01'          | 'pcs'      | 'Store 04'            |
				And "ProductionTree" table became equal
					| 'Item'                                                                                 | 'Surplus store'     | 'Writeoff store'     | 'Unit'     | 'Quantity'       |
					| 'Стремянка номер 6 ступенчатая, Стремянка номер 6 ступенчатая'                         | 'Store 01'          | ''                   | 'pcs'      | '122,000'        |
					| 'Заклепка 6х47 полупустотелая, Заклепка 6х47 полупустотелая'                           | ''                  | 'Store 07'           | 'pcs'      | '1 830,000'      |
					| 'Скобы 3515 (Упаковочные), Скобы 3515 (Упаковочные)'                                   | ''                  | 'Store 07'           | 'pcs'      | '1 220,000'      |
					| 'Втулка на стремянки Класс 10 мм, черный, Втулка на стремянки Класс 10 мм, черный'     | ''                  | 'Store 07'           | 'pcs'      | '610,000'        |
					| 'Катанка Ст3сп 6,5, Катанка Ст3сп 6,5'                                                 | ''                  | 'Store 07'           | 'кг'       | '244,000'        |
					| 'Краска порошковая серая 9006, Краска порошковая серая 9006'                           | ''                  | 'Store 07'           | 'кг'       | '122,000'        |
					| 'труба электросварная круглая 10х1х5660, труба электросварная круглая 10х1х5660'       | ''                  | 'Store 07'           | 'pcs'      | '244,000'        |
					| 'Копыта на стремянки Класс 20х20, черный, Копыта на стремянки Класс 20х20, черный'     | 'Store 01'          | 'Store 04'           | 'pcs'      | '244,000'        |
					| 'ПВД 158, ПВД 158'                                                                     | ''                  | 'Store 07'           | 'кг'       | '239,120'        |
					| 'Коврик для стремянок Класс, черный, Коврик для стремянок Класс, черный'               | ''                  | 'Store 07'           | 'pcs'      | '122,000'        |
					| 'Копыта на стремянки Класс 30х20, черный, Копыта на стремянки Класс 30х20, черный'     | 'Store 01'          | 'Store 04'           | 'pcs'      | '244,000'        |
					| 'ПВД 158, ПВД 158'                                                                     | ''                  | 'Store 02'           | 'кг'       | '463,600'        |
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
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Select button of "Business unit" field
			And I go to line in "List" table
				| 'Description'               |
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
			Then the form attribute named "PlanningPeriodBeginDate" became equal to "$$$$DateStartThirdMonth$$$$"
			And the editing text of form attribute named "PlanningPeriodEndDate" became equal to "$$$$DateEndThirdMonth$$$$"
		* Filling in item tab
			And in the table "Productions" I click the button named "ProductionsAdd"
			And I click choice button of "Item" attribute in "Productions" table
			And I go to line in "List" table
				| 'Description'           |
				| 'Стремянка номер 8'     |
			And I select current line in "List" table
			And I activate "Q" field in "Productions" table
			And I input "131,000" text in "Q" field of "Productions" table
			And I activate "Bill of materials" field in "Productions" table
			And I click choice button of "Bill of materials" attribute in "Productions" table
			And I go to line in "List" table
				| 'Description'                     | 'Item'                 | 'Item key'              |
				| 'Стремянка номер 8 (основная)'    | 'Стремянка номер 8'    | 'Стремянка номер 8'     |
			And I select current line in "List" table
			And I finish line editing in "Productions" table
			And "Productions" table contains lines
				| 'Item'                 | 'Item key'             | 'Unit'    | 'Q'          | 'Bill of materials'                |
				| 'Стремянка номер 8'    | 'Стремянка номер 8'    | 'pcs'     | '131,000'    | 'Стремянка номер 8 (основная)'     |
			And I click the button named "FormPost"
			And I delete "$$NumberProductionPlanning01123112$$" variable
			And I delete "$$ProductionPlanning01123112$$" variable
			And I save the value of "Number" field as "$$NumberProductionPlanning01123112$$"
			And I save the window as "$$ProductionPlanning01123112$$"
			And I click the button named "FormPostAndClose"
	* Creation check
		And "List" table contains lines
			| 'Number'                                 | 'Company'        | 'Business unit'           | 'Planning period'    |
			| '$$NumberProductionPlanning01103110$$'   | 'Main Company'   | 'Склад производства 05'   | 'First month'        |
			| '$$NumberProductionPlanning01113011$$'   | 'Main Company'   | 'Склад производства 05'   | 'Second month'       |
			| '$$NumberProductionPlanning01123112$$'   | 'Main Company'   | 'Склад производства 05'   | 'Third month'        |
		And I close all client application windows
		

Scenario: _1011 check Production planning movements
	* Check movements
		And In the command interface I select "Manufacturing" "Production plannings"
		And I go to line in "List" table
			| 'Number'                                  |
			| '$$NumberProductionPlanning01103110$$'    |
		And I click "Registrations report" button
		And "ResultTable" spreadsheet document contains lines:
			| '$$ProductionPlanning01103110$$'          | ''         | ''                                             | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| 'Document registrations records'          | ''         | ''                                             | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| 'Register  "R7010 Detailing supplies"'    | ''         | ''                                             | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | 'Period'   | 'Resources'                                    | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Dimensions'      | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | ''         | 'Entry demand quantity'                        | 'Corrected demand quantity'   | 'Needed produce quantity'          | 'Produced produce quantity'   | 'Reserved produce quantity'   | 'Written off produce quantity'              | 'Request procurement quantity'              | 'Order transfer quantity'   | 'Confirmed transfer quantity'   | 'Order purchase quantity'                      | 'Confirmed purchase quantity'   | 'Company'         | 'Business unit'           | 'Store'                                     | 'Planning period'   | 'Item key'                                  | ''              | ''             | ''                   |
			| ''                                        | '*'        | '100'                                          | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 07'                                  | 'First month'       | 'Коврик для стремянок Класс, черный'        | ''              | ''             | ''                   |
			| ''                                        | '*'        | '200'                                          | ''                            | '200'                              | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 04'                                  | 'First month'       | 'Копыта на стремянки Класс 30х20, черный'   | ''              | ''             | ''                   |
			| ''                                        | '*'        | '350'                                          | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 07'                                  | 'First month'       | 'Краска порошковая серая 9006'              | ''              | ''             | ''                   |
			| ''                                        | '*'        | '380'                                          | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Цех 06'                  | 'Store 02'                                  | 'First month'       | 'ПВД 158'                                   | ''              | ''             | ''                   |
			| ''                                        | '*'        | '686'                                          | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 07'                                  | 'First month'       | 'ПВД 158'                                   | ''              | ''             | ''                   |
			| ''                                        | '*'        | '700'                                          | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 07'                                  | 'First month'       | 'Катанка Ст3сп 6,5'                         | ''              | ''             | ''                   |
			| ''                                        | '*'        | '700'                                          | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 07'                                  | 'First month'       | 'труба электросварная круглая 10х1х5660'    | ''              | ''             | ''                   |
			| ''                                        | '*'        | '700'                                          | ''                            | '700'                              | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 04'                                  | 'First month'       | 'Копыта на стремянки Класс 20х20, черный'   | ''              | ''             | ''                   |
			| ''                                        | '*'        | '1 500'                                        | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 04'                                  | 'First month'       | 'Заклепка 6х47 полупустотелая'              | ''              | ''             | ''                   |
			| ''                                        | '*'        | '1 750'                                        | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 07'                                  | 'First month'       | 'Втулка на стремянки Класс 10 мм, черный'   | ''              | ''             | ''                   |
			| ''                                        | '*'        | '3 500'                                        | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 07'                                  | 'First month'       | 'Скобы 3515 (Упаковочные)'                  | ''              | ''             | ''                   |
			| ''                                        | '*'        | '3 750'                                        | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 07'                                  | 'First month'       | 'Заклепка 6х47 полупустотелая'              | ''              | ''             | ''                   |
			| ''                                        | ''         | ''                                             | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| 'Register  "R7020 Material planning"'     | ''         | ''                                             | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | 'Period'   | 'Resources'                                    | 'Dimensions'                  | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | ''         | 'Quantity'                                     | 'Company'                     | 'Planning document'                | 'Business unit'               | 'Store'                       | 'Production'                                | 'Item key'                                  | 'Planning type'             | 'Planning period'               | 'Bill of materials'                            | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '100'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 6 ступенчатая'             | 'Краска порошковая серая 9006'              | 'Planned'                   | 'First month'                   | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '100'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 6 ступенчатая'             | 'Коврик для стремянок Класс, черный'        | 'Planned'                   | 'First month'                   | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '196'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Копыта на стремянки Класс 20х20, черный'   | 'ПВД 158'                                   | 'Planned'                   | 'First month'                   | '01 Копыта на стремянки Класс 20х20'           | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '200'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 04'                    | 'Стремянка номер 6 ступенчатая'             | 'Копыта на стремянки Класс 20х20, черный'   | 'Planned'                   | 'First month'                   | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '200'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 04'                    | 'Стремянка номер 6 ступенчатая'             | 'Копыта на стремянки Класс 30х20, черный'   | 'Planned'                   | 'First month'                   | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '200'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 6 ступенчатая'             | 'Катанка Ст3сп 6,5'                         | 'Planned'                   | 'First month'                   | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '200'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 6 ступенчатая'             | 'труба электросварная круглая 10х1х5660'    | 'Planned'                   | 'First month'                   | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '250'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 5 ступенчатая'             | 'Краска порошковая серая 9006'              | 'Planned'                   | 'First month'                   | 'Стремянка номер 5 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '380'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Цех 06'                      | 'Store 02'                    | 'Копыта на стремянки Класс 30х20, черный'   | 'ПВД 158'                                   | 'Planned'                   | 'First month'                   | '01 Копыта на стремянки Класс 30х20, черный'   | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '490'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Копыта на стремянки Класс 20х20, черный'   | 'ПВД 158'                                   | 'Planned'                   | 'First month'                   | '01 Копыта на стремянки Класс 20х20'           | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '500'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 04'                    | 'Стремянка номер 5 ступенчатая'             | 'Копыта на стремянки Класс 20х20, черный'   | 'Planned'                   | 'First month'                   | 'Стремянка номер 5 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '500'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 5 ступенчатая'             | 'Катанка Ст3сп 6,5'                         | 'Planned'                   | 'First month'                   | 'Стремянка номер 5 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '500'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 5 ступенчатая'             | 'труба электросварная круглая 10х1х5660'    | 'Planned'                   | 'First month'                   | 'Стремянка номер 5 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '500'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 6 ступенчатая'             | 'Втулка на стремянки Класс 10 мм, черный'   | 'Planned'                   | 'First month'                   | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '1 000'                                        | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 6 ступенчатая'             | 'Скобы 3515 (Упаковочные)'                  | 'Planned'                   | 'First month'                   | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '1 250'                                        | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 5 ступенчатая'             | 'Втулка на стремянки Класс 10 мм, черный'   | 'Planned'                   | 'First month'                   | 'Стремянка номер 5 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '1 500'                                        | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 04'                    | 'Стремянка номер 6 ступенчатая'             | 'Заклепка 6х47 полупустотелая'              | 'Planned'                   | 'First month'                   | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '2 500'                                        | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 5 ступенчатая'             | 'Скобы 3515 (Упаковочные)'                  | 'Planned'                   | 'First month'                   | 'Стремянка номер 5 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '3 750'                                        | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 5 ступенчатая'             | 'Заклепка 6х47 полупустотелая'              | 'Planned'                   | 'First month'                   | 'Стремянка номер 5 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | ''         | ''                                             | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| 'Register  "R7030 Production planning"'   | ''         | ''                                             | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | 'Period'   | 'Resources'                                    | 'Dimensions'                  | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | ''         | 'Quantity'                                     | 'Company'                     | 'Planning document'                | 'Business unit'               | 'Store'                       | 'Item key'                                  | 'Planning type'                             | 'Planning period'           | 'Production type'               | 'Bill of materials'                            | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '100'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 01'                    | 'Стремянка номер 6 ступенчатая'             | 'Planned'                                   | 'First month'               | 'Product'                       | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '200'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 01'                    | 'Копыта на стремянки Класс 20х20, черный'   | 'Planned'                                   | 'First month'               | 'Semiproduct'                   | '01 Копыта на стремянки Класс 20х20'           | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '200'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Цех 06'                      | 'Store 01'                    | 'Копыта на стремянки Класс 30х20, черный'   | 'Planned'                                   | 'First month'               | 'Semiproduct'                   | '01 Копыта на стремянки Класс 30х20, черный'   | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '250'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 01'                    | 'Стремянка номер 5 ступенчатая'             | 'Planned'                                   | 'First month'               | 'Product'                       | 'Стремянка номер 5 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '500'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 01'                    | 'Копыта на стремянки Класс 20х20, черный'   | 'Planned'                                   | 'First month'               | 'Semiproduct'                   | '01 Копыта на стремянки Класс 20х20'           | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | ''         | ''                                             | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| 'Register  "T7010 Bill of materials"'     | ''         | ''                                             | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | 'Period'   | 'Resources'                                    | ''                            | ''                                 | ''                            | ''                            | 'Dimensions'                                | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | ''         | 'Bill of materials'                            | 'Unit'                        | 'Quantity'                         | 'Basis unit'                  | 'Basis quantity'              | 'Company'                                   | 'Planning document'                         | 'Business unit'             | 'Input ID'                      | 'Output ID'                                    | 'Unique ID'                     | 'Surplus store'   | 'Writeoff store'          | 'Item key'                                  | 'Is product'        | 'Is semiproduct'                            | 'Is material'   | 'Is service'   | 'Planning period'    |
			| ''                                        | '*'        | ''                                             | 'pcs'                         | '100'                              | 'pcs'                         | '100'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Коврик для стремянок Класс, черный'        | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'pcs'                         | '200'                              | 'pcs'                         | '200'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'труба электросварная круглая 10х1х5660'    | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'pcs'                         | '500'                              | 'pcs'                         | '500'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Втулка на стремянки Класс 10 мм, черный'   | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'pcs'                         | '500'                              | 'pcs'                         | '500'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'труба электросварная круглая 10х1х5660'    | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'pcs'                         | '1 000'                            | 'pcs'                         | '1 000'                       | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Скобы 3515 (Упаковочные)'                  | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'pcs'                         | '1 250'                            | 'pcs'                         | '1 250'                       | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Втулка на стремянки Класс 10 мм, черный'   | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'pcs'                         | '1 500'                            | 'pcs'                         | '1 500'                       | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 04'                | 'Заклепка 6х47 полупустотелая'              | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'pcs'                         | '2 500'                            | 'pcs'                         | '2 500'                       | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Скобы 3515 (Упаковочные)'                  | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'pcs'                         | '3 750'                            | 'pcs'                         | '3 750'                       | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Заклепка 6х47 полупустотелая'              | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'кг'                          | '100'                              | 'кг'                          | '100'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Краска порошковая серая 9006'              | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'кг'                          | '196'                              | 'кг'                          | '196'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'ПВД 158'                                   | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'кг'                          | '200'                              | 'кг'                          | '200'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Катанка Ст3сп 6,5'                         | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'кг'                          | '250'                              | 'кг'                          | '250'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Краска порошковая серая 9006'              | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'кг'                          | '380'                              | 'кг'                          | '380'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Цех 06'                    | '*'                             | ''                                             | '*'                             | ''                | 'Store 02'                | 'ПВД 158'                                   | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'кг'                          | '490'                              | 'кг'                          | '490'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'ПВД 158'                                   | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'кг'                          | '500'                              | 'кг'                          | '500'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Катанка Ст3сп 6,5'                         | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | '01 Копыта на стремянки Класс 20х20'           | 'pcs'                         | '200'                              | 'pcs'                         | '200'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | '*'                                            | '*'                             | 'Store 01'        | 'Store 04'                | 'Копыта на стремянки Класс 20х20, черный'   | 'No'                | 'Yes'                                       | 'No'            | 'No'           | 'First month'        |
			| ''                                        | '*'        | '01 Копыта на стремянки Класс 20х20'           | 'pcs'                         | '500'                              | 'pcs'                         | '500'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | '*'                                            | '*'                             | 'Store 01'        | 'Store 04'                | 'Копыта на стремянки Класс 20х20, черный'   | 'No'                | 'Yes'                                       | 'No'            | 'No'           | 'First month'        |
			| ''                                        | '*'        | '01 Копыта на стремянки Класс 30х20, черный'   | 'pcs'                         | '200'                              | 'pcs'                         | '200'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Цех 06'                    | '*'                             | '*'                                            | '*'                             | 'Store 01'        | 'Store 04'                | 'Копыта на стремянки Класс 30х20, черный'   | 'No'                | 'Yes'                                       | 'No'            | 'No'           | 'First month'        |
			| ''                                        | '*'        | 'Стремянка номер 5 ступенчатая'                | 'pcs'                         | '250'                              | 'pcs'                         | '250'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | ''                              | '*'                                            | '*'                             | 'Store 01'        | ''                        | 'Стремянка номер 5 ступенчатая'             | 'Yes'               | 'No'                                        | 'No'            | 'No'           | 'First month'        |
			| ''                                        | '*'        | 'Стремянка номер 6 ступенчатая'                | 'pcs'                         | '100'                              | 'pcs'                         | '100'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | ''                              | '*'                                            | '*'                             | 'Store 01'        | ''                        | 'Стремянка номер 6 ступенчатая'             | 'Yes'               | 'No'                                        | 'No'            | 'No'           | 'First month'        |
		And I close current window
	* Clear movements and check that there is no movement on the registers
		* Clear movements
			Given I open hyperlink "e1cib/list/Document.ProductionPlanning"
			And I go to line in "List" table
				| 'Number'                                   |
				| '$$NumberProductionPlanning01103110$$'     |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		* Check that there is no movement on the registers
			Given I open hyperlink "e1cib/list/AccumulationRegister.R7030T_ProductionPlanning"
			And "List" table does not contain lines
				| 'Recorder'                           |
				| '$$ProductionPlanning01103110$$'     |
			Given I open hyperlink "e1cib/list/InformationRegister.T7010S_BillOfMaterials"
			And "List" table does not contain lines
				| 'Recorder'                           |
				| '$$ProductionPlanning01103110$$'     |
			And I close all client application windows
	* Re-posting the document and checking movements on the registers
		* Posting the document
			Given I open hyperlink "e1cib/list/Document.ProductionPlanning"
			And I go to line in "List" table
				| 'Number'                                   |
				| '$$NumberProductionPlanning01103110$$'     |
			And in the table "List" I click the button named "ListContextMenuPost"
		* Check movements
			And I click "Registrations report" button
			And "ResultTable" spreadsheet document contains lines:
			| '$$ProductionPlanning01103110$$'          | ''         | ''                                             | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| 'Document registrations records'          | ''         | ''                                             | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| 'Register  "R7010 Detailing supplies"'    | ''         | ''                                             | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | 'Period'   | 'Resources'                                    | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Dimensions'      | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | ''         | 'Entry demand quantity'                        | 'Corrected demand quantity'   | 'Needed produce quantity'          | 'Produced produce quantity'   | 'Reserved produce quantity'   | 'Written off produce quantity'              | 'Request procurement quantity'              | 'Order transfer quantity'   | 'Confirmed transfer quantity'   | 'Order purchase quantity'                      | 'Confirmed purchase quantity'   | 'Company'         | 'Business unit'           | 'Store'                                     | 'Planning period'   | 'Item key'                                  | ''              | ''             | ''                   |
			| ''                                        | '*'        | '100'                                          | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 07'                                  | 'First month'       | 'Коврик для стремянок Класс, черный'        | ''              | ''             | ''                   |
			| ''                                        | '*'        | '200'                                          | ''                            | '200'                              | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 04'                                  | 'First month'       | 'Копыта на стремянки Класс 30х20, черный'   | ''              | ''             | ''                   |
			| ''                                        | '*'        | '350'                                          | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 07'                                  | 'First month'       | 'Краска порошковая серая 9006'              | ''              | ''             | ''                   |
			| ''                                        | '*'        | '380'                                          | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Цех 06'                  | 'Store 02'                                  | 'First month'       | 'ПВД 158'                                   | ''              | ''             | ''                   |
			| ''                                        | '*'        | '686'                                          | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 07'                                  | 'First month'       | 'ПВД 158'                                   | ''              | ''             | ''                   |
			| ''                                        | '*'        | '700'                                          | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 07'                                  | 'First month'       | 'Катанка Ст3сп 6,5'                         | ''              | ''             | ''                   |
			| ''                                        | '*'        | '700'                                          | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 07'                                  | 'First month'       | 'труба электросварная круглая 10х1х5660'    | ''              | ''             | ''                   |
			| ''                                        | '*'        | '700'                                          | ''                            | '700'                              | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 04'                                  | 'First month'       | 'Копыта на стремянки Класс 20х20, черный'   | ''              | ''             | ''                   |
			| ''                                        | '*'        | '1 500'                                        | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 04'                                  | 'First month'       | 'Заклепка 6х47 полупустотелая'              | ''              | ''             | ''                   |
			| ''                                        | '*'        | '1 750'                                        | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 07'                                  | 'First month'       | 'Втулка на стремянки Класс 10 мм, черный'   | ''              | ''             | ''                   |
			| ''                                        | '*'        | '3 500'                                        | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 07'                                  | 'First month'       | 'Скобы 3515 (Упаковочные)'                  | ''              | ''             | ''                   |
			| ''                                        | '*'        | '3 750'                                        | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | 'Main Company'    | 'Склад производства 05'   | 'Store 07'                                  | 'First month'       | 'Заклепка 6х47 полупустотелая'              | ''              | ''             | ''                   |
			| ''                                        | ''         | ''                                             | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| 'Register  "R7020 Material planning"'     | ''         | ''                                             | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | 'Period'   | 'Resources'                                    | 'Dimensions'                  | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | ''         | 'Quantity'                                     | 'Company'                     | 'Planning document'                | 'Business unit'               | 'Store'                       | 'Production'                                | 'Item key'                                  | 'Planning type'             | 'Planning period'               | 'Bill of materials'                            | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '100'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 6 ступенчатая'             | 'Краска порошковая серая 9006'              | 'Planned'                   | 'First month'                   | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '100'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 6 ступенчатая'             | 'Коврик для стремянок Класс, черный'        | 'Planned'                   | 'First month'                   | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '196'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Копыта на стремянки Класс 20х20, черный'   | 'ПВД 158'                                   | 'Planned'                   | 'First month'                   | '01 Копыта на стремянки Класс 20х20'           | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '200'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 04'                    | 'Стремянка номер 6 ступенчатая'             | 'Копыта на стремянки Класс 20х20, черный'   | 'Planned'                   | 'First month'                   | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '200'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 04'                    | 'Стремянка номер 6 ступенчатая'             | 'Копыта на стремянки Класс 30х20, черный'   | 'Planned'                   | 'First month'                   | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '200'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 6 ступенчатая'             | 'Катанка Ст3сп 6,5'                         | 'Planned'                   | 'First month'                   | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '200'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 6 ступенчатая'             | 'труба электросварная круглая 10х1х5660'    | 'Planned'                   | 'First month'                   | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '250'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 5 ступенчатая'             | 'Краска порошковая серая 9006'              | 'Planned'                   | 'First month'                   | 'Стремянка номер 5 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '380'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Цех 06'                      | 'Store 02'                    | 'Копыта на стремянки Класс 30х20, черный'   | 'ПВД 158'                                   | 'Planned'                   | 'First month'                   | '01 Копыта на стремянки Класс 30х20, черный'   | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '490'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Копыта на стремянки Класс 20х20, черный'   | 'ПВД 158'                                   | 'Planned'                   | 'First month'                   | '01 Копыта на стремянки Класс 20х20'           | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '500'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 04'                    | 'Стремянка номер 5 ступенчатая'             | 'Копыта на стремянки Класс 20х20, черный'   | 'Planned'                   | 'First month'                   | 'Стремянка номер 5 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '500'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 5 ступенчатая'             | 'Катанка Ст3сп 6,5'                         | 'Planned'                   | 'First month'                   | 'Стремянка номер 5 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '500'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 5 ступенчатая'             | 'труба электросварная круглая 10х1х5660'    | 'Planned'                   | 'First month'                   | 'Стремянка номер 5 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '500'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 6 ступенчатая'             | 'Втулка на стремянки Класс 10 мм, черный'   | 'Planned'                   | 'First month'                   | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '1 000'                                        | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 6 ступенчатая'             | 'Скобы 3515 (Упаковочные)'                  | 'Planned'                   | 'First month'                   | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '1 250'                                        | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 5 ступенчатая'             | 'Втулка на стремянки Класс 10 мм, черный'   | 'Planned'                   | 'First month'                   | 'Стремянка номер 5 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '1 500'                                        | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 04'                    | 'Стремянка номер 6 ступенчатая'             | 'Заклепка 6х47 полупустотелая'              | 'Planned'                   | 'First month'                   | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '2 500'                                        | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 5 ступенчатая'             | 'Скобы 3515 (Упаковочные)'                  | 'Planned'                   | 'First month'                   | 'Стремянка номер 5 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '3 750'                                        | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 07'                    | 'Стремянка номер 5 ступенчатая'             | 'Заклепка 6х47 полупустотелая'              | 'Planned'                   | 'First month'                   | 'Стремянка номер 5 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | ''         | ''                                             | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| 'Register  "R7030 Production planning"'   | ''         | ''                                             | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | 'Period'   | 'Resources'                                    | 'Dimensions'                  | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | ''         | 'Quantity'                                     | 'Company'                     | 'Planning document'                | 'Business unit'               | 'Store'                       | 'Item key'                                  | 'Planning type'                             | 'Planning period'           | 'Production type'               | 'Bill of materials'                            | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '100'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 01'                    | 'Стремянка номер 6 ступенчатая'             | 'Planned'                                   | 'First month'               | 'Product'                       | 'Стремянка номер 6 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '200'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 01'                    | 'Копыта на стремянки Класс 20х20, черный'   | 'Planned'                                   | 'First month'               | 'Semiproduct'                   | '01 Копыта на стремянки Класс 20х20'           | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '200'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Цех 06'                      | 'Store 01'                    | 'Копыта на стремянки Класс 30х20, черный'   | 'Planned'                                   | 'First month'               | 'Semiproduct'                   | '01 Копыта на стремянки Класс 30х20, черный'   | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '250'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 01'                    | 'Стремянка номер 5 ступенчатая'             | 'Planned'                                   | 'First month'               | 'Product'                       | 'Стремянка номер 5 ступенчатая'                | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | '*'        | '500'                                          | 'Main Company'                | '$$ProductionPlanning01103110$$'   | 'Склад производства 05'       | 'Store 01'                    | 'Копыта на стремянки Класс 20х20, черный'   | 'Planned'                                   | 'First month'               | 'Semiproduct'                   | '01 Копыта на стремянки Класс 20х20'           | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | ''         | ''                                             | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| 'Register  "T7010 Bill of materials"'     | ''         | ''                                             | ''                            | ''                                 | ''                            | ''                            | ''                                          | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | 'Period'   | 'Resources'                                    | ''                            | ''                                 | ''                            | ''                            | 'Dimensions'                                | ''                                          | ''                          | ''                              | ''                                             | ''                              | ''                | ''                        | ''                                          | ''                  | ''                                          | ''              | ''             | ''                   |
			| ''                                        | ''         | 'Bill of materials'                            | 'Unit'                        | 'Quantity'                         | 'Basis unit'                  | 'Basis quantity'              | 'Company'                                   | 'Planning document'                         | 'Business unit'             | 'Input ID'                      | 'Output ID'                                    | 'Unique ID'                     | 'Surplus store'   | 'Writeoff store'          | 'Item key'                                  | 'Is product'        | 'Is semiproduct'                            | 'Is material'   | 'Is service'   | 'Planning period'    |
			| ''                                        | '*'        | ''                                             | 'pcs'                         | '100'                              | 'pcs'                         | '100'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Коврик для стремянок Класс, черный'        | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'pcs'                         | '200'                              | 'pcs'                         | '200'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'труба электросварная круглая 10х1х5660'    | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'pcs'                         | '500'                              | 'pcs'                         | '500'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Втулка на стремянки Класс 10 мм, черный'   | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'pcs'                         | '500'                              | 'pcs'                         | '500'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'труба электросварная круглая 10х1х5660'    | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'pcs'                         | '1 000'                            | 'pcs'                         | '1 000'                       | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Скобы 3515 (Упаковочные)'                  | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'pcs'                         | '1 250'                            | 'pcs'                         | '1 250'                       | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Втулка на стремянки Класс 10 мм, черный'   | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'pcs'                         | '1 500'                            | 'pcs'                         | '1 500'                       | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 04'                | 'Заклепка 6х47 полупустотелая'              | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'pcs'                         | '2 500'                            | 'pcs'                         | '2 500'                       | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Скобы 3515 (Упаковочные)'                  | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'pcs'                         | '3 750'                            | 'pcs'                         | '3 750'                       | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Заклепка 6х47 полупустотелая'              | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'кг'                          | '100'                              | 'кг'                          | '100'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Краска порошковая серая 9006'              | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'кг'                          | '196'                              | 'кг'                          | '196'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'ПВД 158'                                   | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'кг'                          | '200'                              | 'кг'                          | '200'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Катанка Ст3сп 6,5'                         | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'кг'                          | '250'                              | 'кг'                          | '250'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Краска порошковая серая 9006'              | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'кг'                          | '380'                              | 'кг'                          | '380'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Цех 06'                    | '*'                             | ''                                             | '*'                             | ''                | 'Store 02'                | 'ПВД 158'                                   | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'кг'                          | '490'                              | 'кг'                          | '490'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'ПВД 158'                                   | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | ''                                             | 'кг'                          | '500'                              | 'кг'                          | '500'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | ''                                             | '*'                             | ''                | 'Store 07'                | 'Катанка Ст3сп 6,5'                         | 'No'                | 'No'                                        | 'Yes'           | 'No'           | 'First month'        |
			| ''                                        | '*'        | '01 Копыта на стремянки Класс 20х20'           | 'pcs'                         | '200'                              | 'pcs'                         | '200'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | '*'                                            | '*'                             | 'Store 01'        | 'Store 04'                | 'Копыта на стремянки Класс 20х20, черный'   | 'No'                | 'Yes'                                       | 'No'            | 'No'           | 'First month'        |
			| ''                                        | '*'        | '01 Копыта на стремянки Класс 20х20'           | 'pcs'                         | '500'                              | 'pcs'                         | '500'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | '*'                             | '*'                                            | '*'                             | 'Store 01'        | 'Store 04'                | 'Копыта на стремянки Класс 20х20, черный'   | 'No'                | 'Yes'                                       | 'No'            | 'No'           | 'First month'        |
			| ''                                        | '*'        | '01 Копыта на стремянки Класс 30х20, черный'   | 'pcs'                         | '200'                              | 'pcs'                         | '200'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Цех 06'                    | '*'                             | '*'                                            | '*'                             | 'Store 01'        | 'Store 04'                | 'Копыта на стремянки Класс 30х20, черный'   | 'No'                | 'Yes'                                       | 'No'            | 'No'           | 'First month'        |
			| ''                                        | '*'        | 'Стремянка номер 5 ступенчатая'                | 'pcs'                         | '250'                              | 'pcs'                         | '250'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | ''                              | '*'                                            | '*'                             | 'Store 01'        | ''                        | 'Стремянка номер 5 ступенчатая'             | 'Yes'               | 'No'                                        | 'No'            | 'No'           | 'First month'        |
			| ''                                        | '*'        | 'Стремянка номер 6 ступенчатая'                | 'pcs'                         | '100'                              | 'pcs'                         | '100'                         | 'Main Company'                              | '$$ProductionPlanning01103110$$'            | 'Склад производства 05'     | ''                              | '*'                                            | '*'                             | 'Store 01'        | ''                        | 'Стремянка номер 6 ступенчатая'             | 'Yes'               | 'No'                                        | 'No'            | 'No'           | 'First month'        |
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
// 		| 'Стремянка номер 6 ступенчатая, Perilla'          | 'Produce'        | 'pcs'         | 'pcs'   | '100,000'   | '100,000'   |
// 		| 'Заклепка 6х47 полупустотелая, Стандартный'            | 'Supply request' | 'pcs'         | 'pcs'   | '1 500,000' | '1 500,000' |
// 		| 'Скобы 3515 (Упаковочные), Стандартный'                | 'Supply request' | 'pcs'         | 'pcs'   | '1 000,000' | '1 000,000' |
// 		| 'Втулка на стремянки Класс 10 мм, черный, Стандартный' | 'Supply request' | 'pcs'         | 'pcs'   | '500,000'   | '500,000'   |
// 		| 'Катанка Ст3сп 6,5, Стандартный'                       | 'Supply request' | 'кг'         | 'кг'   | '200,000'   | '200,000'   |
// 		| 'Краска порошковая серая 9006, Стандартный'            | 'Supply request' | 'кг'         | 'кг'   | '100,000'   | '100,000'   |
// 		| 'труба электросварная круглая 10х1х5660, Стандартный'  | 'Supply request' | 'pcs'         | 'pcs'   | '200,000'   | '200,000'   |
// 		| 'Копыта на стремянки Класс 20х20, черный, Стандартный' | 'Produce'        | 'pcs'         | 'pcs'   | '200,000'   | '200,000'   |
// 		| 'ПВД 158, Стандартный'                                 | 'Supply request' | 'кг'         | 'кг'   | '196,000'   | '196,000'   |
// 		| 'Коврик для стремянок Класс, черный, Стандартный'      | 'Supply request' | 'pcs'         | 'pcs'   | '100,000'   | '100,000'   |
// 		| 'Копыта на стремянки Класс 30х20, черный, Стандартный' | 'Produce'        | 'pcs'         | 'pcs'   | '200,000'   | '200,000'   |
// 		| 'ПВД 158, Стандартный'                                 | 'Supply request' | 'кг'         | 'кг'   | '380,000'   | '380,000'   |
// 		| 'Стремянка номер 5 ступенчатая, Perilla'          | 'Produce'        | 'pcs'         | 'pcs'   | '250,000'   | '250,000'   |
// 		| 'Заклепка 6х47 полупустотелая, Стандартный'            | 'Supply request' | 'pcs'         | 'pcs'   | '3 750,000' | '3 750,000' |
// 		| 'Скобы 3515 (Упаковочные), Стандартный'                | 'Supply request' | 'pcs'         | 'pcs'   | '2 500,000' | '2 500,000' |
// 		| 'Втулка на стремянки Класс 10 мм, черный, Стандартный' | 'Supply request' | 'pcs'         | 'pcs'   | '1 250,000' | '1 250,000' |
// 		| 'Катанка Ст3сп 6,5, Стандартный'                       | 'Supply request' | 'кг'         | 'кг'   | '500,000'   | '500,000'   |
// 		| 'Краска порошковая серая 9006, Стандартный'            | 'Supply request' | 'кг'         | 'кг'   | '250,000'   | '250,000'   |
// 		| 'труба электросварная круглая 10х1х5660, Стандартный'  | 'Supply request' | 'pcs'         | 'pcs'   | '500,000'   | '500,000'   |
// 		| 'Копыта на стремянки Класс 20х20, черный, Стандартный' | 'Produce'        | 'pcs'         | 'pcs'   | '500,000'   | '500,000'   |
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
// 		| 'Заклепка 6х47 полупустотелая'            | 'Стандартный' | '5 250,000' | 'pcs'   |
// 		| 'Катанка Ст3сп 6,5'                       | 'Стандартный' | '700,000'   | 'кг'   |
// 		| 'Краска порошковая серая 9006'            | 'Стандартный' | '350,000'   | 'кг'   |
// 		| 'труба электросварная круглая 10х1х5660'  | 'Стандартный' | '700,000'   | 'pcs'   |
// 		| 'ПВД 158'                                 | 'Стандартный' | '1 066,000' | 'кг'   |
// 		| 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный' | '1 750,000' | 'pcs'   |
// 		| 'Скобы 3515 (Упаковочные)'                | 'Стандартный' | '3 500,000' | 'pcs'   |
// 		| 'Коврик для стремянок Класс, черный'      | 'Стандартный' | '100,000'   | 'pcs'   |
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
// 			| '122,000' | 'pcs'         | 'Produce'     | 'Стремянка номер 6 ступенчатая, Perilla' | '122,000' | 'pcs'   |
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
// 			| 'труба электросварная круглая 10х1х5660'  | 'Стандартный' | '244,000'   | 'pcs'   |
// 			| 'Втулка на стремянки Класс 10 мм, черный' | 'Стандартный' | '610,000'   | 'pcs'   |
// 			| 'Скобы 3515 (Упаковочные)'                | 'Стандартный' | '1 220,000' | 'pcs'   |
// 			| 'Заклепка 6х47 полупустотелая'            | 'Стандартный' | '1 830,000' | 'pcs'   |
// 			| 'Катанка Ст3сп 6,5'                       | 'Стандартный' | '244,000'   | 'кг'   |
// 			| 'Коврик для стремянок Класс, черный'      | 'Стандартный' | '122,000'   | 'pcs'   |
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
		And In the command interface I select "Manufacturing" "Productions"
		And I click the button named "FormCreate"
		* Filling in header info
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Select button of "Business unit" field
			And I go to line in "List" table
				| 'Description'               |
				| 'Склад производства 05'     |
			And I select current line in "List" table
			And I click Select button of "Production planning" field
			And I go to line in "List" table
				| 'Number'                                   |
				| '$$NumberProductionPlanning01103110$$'     |
			And I select current line in "List" table
			Then the form attribute named "PlanningPeriod" became equal to "First month"
		* Filling in production tab
			And I move to "Production" tab
			And I click Choice button of the field named "Item"
			And I go to line in "List" table
				| 'Description'                                 |
				| 'Копыта на стремянки Класс 20х20, черный'     |
			And I select current line in "List" table
			Then the form attribute named "ItemKey" became equal to "Копыта на стремянки Класс 20х20, черный"
			And I click Select button of "Bill of materials" field
			And I go to line in "List" table
				| 'Description'                           | 'Item'                                        |
				| '01 Копыта на стремянки Класс 20х20'    | 'Копыта на стремянки Класс 20х20, черный'     |
			And I select current line in "List" table		
			
			Then the form attribute named "Unit" became equal to "pcs"
			And I input "20,000" text in the field named "Quantity"
			And I move to "Materials" tab	
			And "Materials" table contains lines
				| '#'    | 'Item'       | 'Item key'    | 'Unit'    | 'Q'          |
				| '1'    | 'ПВД 158'    | 'ПВД 158'     | 'кг'      | '19,600'     |
			Then the number of "Materials" table lines is "меньше или равно" "1"
			And I click Select button of "Store production" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 05'        |
			And I select current line in "List" table
			And I select current line in "Materials" table
			And I select "Material" exact value from "Material type" drop-down list in "Materials" table
			And I activate field named "MaterialsLineNumber" in "Materials" table
			And I activate "Material type" field in "Materials" table	
			And I activate "Writeoff store" field in "Materials" table
			And I select current line in "Materials" table
			And I click choice button of "Writeoff store" attribute in "Materials" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 05'        |
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
				| 'Register  "R4011 Free stocks"'    | ''               | ''                        | ''             | ''              | ''                                            |
				| ''                                 | 'Record type'    | 'Period'                  | 'Resources'    | 'Dimensions'    | ''                                            |
				| ''                                 | ''               | ''                        | 'Quantity'     | 'Store'         | 'Item key'                                    |
				| ''                                 | 'Receipt'        | '$$DateProduction02$$'    | '20'           | 'Store 05'      | 'Копыта на стремянки Класс 20х20, черный'     |
				| ''                                 | 'Expense'        | '$$DateProduction02$$'    | '19,6'         | 'Store 05'      | 'ПВД 158'                                     |
			And I select "R4010 Actual stocks" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| 'Register  "R4010 Actual stocks"'    | ''               | ''                        | ''             | ''              | ''                                           | ''                      |
				| ''                                   | 'Record type'    | 'Period'                  | 'Resources'    | 'Dimensions'    | ''                                           | ''                      |
				| ''                                   | ''               | ''                        | 'Quantity'     | 'Store'         | 'Item key'                                   | 'Serial lot number'     |
				| ''                                   | 'Receipt'        | '$$DateProduction02$$'    | '20'           | 'Store 05'      | 'Копыта на стремянки Класс 20х20, черный'    | ''                      |
				| ''                                   | 'Expense'        | '$$DateProduction02$$'    | '19,6'         | 'Store 05'      | 'ПВД 158'                                    | ''                      |
			And I input "" text in "Register" field
			And I select "R7010 Detailing supplies" exact value from "Register" drop-down list
			And I click "Generate report" button			
			Then "ResultTable" spreadsheet document is equal
				| '$$Production02$$'                        | ''                        | ''                         | ''                             | ''                           | ''                             | ''                             | ''                                | ''                                | ''                           | ''                               | ''                           | ''                               | ''                | ''                         | ''            | ''                   | ''             |
				| 'Document registrations records'          | ''                        | ''                         | ''                             | ''                           | ''                             | ''                             | ''                                | ''                                | ''                           | ''                               | ''                           | ''                               | ''                | ''                         | ''            | ''                   | ''             |
				| 'Register  "R7010 Detailing supplies"'    | ''                        | ''                         | ''                             | ''                           | ''                             | ''                             | ''                                | ''                                | ''                           | ''                               | ''                           | ''                               | ''                | ''                         | ''            | ''                   | ''             |
				| ''                                        | 'Period'                  | 'Resources'                | ''                             | ''                           | ''                             | ''                             | ''                                | ''                                | ''                           | ''                               | ''                           | ''                               | 'Dimensions'      | ''                         | ''            | ''                   | ''             |
				| ''                                        | ''                        | 'Entry demand quantity'    | 'Corrected demand quantity'    | 'Needed produce quantity'    | 'Produced produce quantity'    | 'Reserved produce quantity'    | 'Written off produce quantity'    | 'Request procurement quantity'    | 'Order transfer quantity'    | 'Confirmed transfer quantity'    | 'Order purchase quantity'    | 'Confirmed purchase quantity'    | 'Company'         | 'Business unit'            | 'Store'       | 'Planning period'    | 'Item key'     |
				| ''                                        | '$$DateProduction02$$'    | ''                         | ''                             | ''                           | ''                             | ''                             | '19,6'                            | ''                                | ''                           | ''                               | ''                           | ''                               | 'Main Company'    | 'Склад производства 05'    | 'Store 05'    | 'First month'        | 'ПВД 158'      |
			And I select "R7020 Material planning" exact value from "Register" drop-down list
			And I click "Generate report" button			
			Then "ResultTable" spreadsheet document is equal
				| '$$Production02$$'                       | ''                        | ''             | ''                | ''                                  | ''                         | ''            | ''                                           | ''            | ''                 | ''                   | ''                                       |
				| 'Document registrations records'         | ''                        | ''             | ''                | ''                                  | ''                         | ''            | ''                                           | ''            | ''                 | ''                   | ''                                       |
				| 'Register  "R7020 Material planning"'    | ''                        | ''             | ''                | ''                                  | ''                         | ''            | ''                                           | ''            | ''                 | ''                   | ''                                       |
				| ''                                       | 'Period'                  | 'Resources'    | 'Dimensions'      | ''                                  | ''                         | ''            | ''                                           | ''            | ''                 | ''                   | ''                                       |
				| ''                                       | ''                        | 'Quantity'     | 'Company'         | 'Planning document'                 | 'Business unit'            | 'Store'       | 'Production'                                 | 'Item key'    | 'Planning type'    | 'Planning period'    | 'Bill of materials'                      |
				| ''                                       | '$$DateProduction02$$'    | '19,6'         | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Копыта на стремянки Класс 20х20, черный'    | 'ПВД 158'     | 'Produced'         | 'First month'        | '01 Копыта на стремянки Класс 20х20'     |
			And I select "R7030 Production planning" exact value from "Register" drop-down list
			And I click "Generate report" button			
			Then "ResultTable" spreadsheet document is equal
				| '$$Production02$$'                         | ''                        | ''             | ''                | ''                                  | ''                         | ''            | ''                                           | ''                 | ''                   | ''                   | ''                                       |
				| 'Document registrations records'           | ''                        | ''             | ''                | ''                                  | ''                         | ''            | ''                                           | ''                 | ''                   | ''                   | ''                                       |
				| 'Register  "R7030 Production planning"'    | ''                        | ''             | ''                | ''                                  | ''                         | ''            | ''                                           | ''                 | ''                   | ''                   | ''                                       |
				| ''                                         | 'Period'                  | 'Resources'    | 'Dimensions'      | ''                                  | ''                         | ''            | ''                                           | ''                 | ''                   | ''                   | ''                                       |
				| ''                                         | ''                        | 'Quantity'     | 'Company'         | 'Planning document'                 | 'Business unit'            | 'Store'       | 'Item key'                                   | 'Planning type'    | 'Planning period'    | 'Production type'    | 'Bill of materials'                      |
				| ''                                         | '$$DateProduction02$$'    | '20'           | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Копыта на стремянки Класс 20х20, черный'    | 'Produced'         | 'First month'        | 'Product'            | '01 Копыта на стремянки Класс 20х20'     |
			And I select "R7040 Manual materials corretion in production" exact value from "Register" drop-down list
			And I click "Generate report" button			
			Then "ResultTable" spreadsheet document is equal
				| '$$Production02$$'                                              | ''                        | ''             | ''                | ''                | ''                         | ''                                      | ''                   | ''                | ''             |
				| 'Document registrations records'                                | ''                        | ''             | ''                | ''                | ''                         | ''                                      | ''                   | ''                | ''             |
				| 'Register  "R7040 Manual materials corretion in production"'    | ''                        | ''             | ''                | ''                | ''                         | ''                                      | ''                   | ''                | ''             |
				| ''                                                              | 'Period'                  | 'Resources'    | ''                | 'Dimensions'      | ''                         | ''                                      | ''                   | ''                | ''             |
				| ''                                                              | ''                        | 'Quantity'     | 'Quantity BOM'    | 'Company'         | 'Business unit'            | 'Bill of materials'                     | 'Planning period'    | 'Item key BOM'    | 'Item key'     |
				| ''                                                              | '$$DateProduction02$$'    | '19,6'         | '19,6'            | 'Main Company'    | 'Склад производства 05'    | '01 Копыта на стремянки Класс 20х20'    | 'First month'        | 'ПВД 158'         | 'ПВД 158'      |
			And I close all client application windows
	* Product
		Given I open hyperlink "e1cib/list/Document.Production"
		And I click the button named "FormCreate"
		* Filling in header info
			And I click Select button of "Company" field
			And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
			And I select current line in "List" table
			And I click Select button of "Business unit" field
			And I go to line in "List" table
				| 'Description'               |
				| 'Склад производства 05'     |
			And I select current line in "List" table
			And I click Select button of "Store production" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 05'        |
			And I select current line in "List" table			
			Then the form attribute named "ProductionPlanning" became equal to "$$ProductionPlanning01103110$$"			
		* Filling in production tab
			And I click Choice button of the field named "Item"
			And I go to line in "List" table
				| 'Description'                       |
				| 'Стремянка номер 6 ступенчатая'     |
			And I select current line in "List" table
			Then the form attribute named "ItemKey" became equal to "Стремянка номер 6 ступенчатая"
			Then the form attribute named "BillOfMaterials" became equal to "Стремянка номер 6 ступенчатая"
			Then the form attribute named "Unit" became equal to "pcs"
			And I input "10,000" text in the field named "Quantity"
			And I move to "Materials" tab			
			And "Materials" table contains lines
				| 'Item'                                       | 'Item key'                                   | 'Unit'    | 'Q'           |
				| 'Заклепка 6х47 полупустотелая'               | 'Заклепка 6х47 полупустотелая'               | 'pcs'     | '150,000'     |
				| 'Скобы 3515 (Упаковочные)'                   | 'Скобы 3515 (Упаковочные)'                   | 'pcs'     | '100,000'     |
				| 'Втулка на стремянки Класс 10 мм, черный'    | 'Втулка на стремянки Класс 10 мм, черный'    | 'pcs'     | '50,000'      |
				| 'Катанка Ст3сп 6,5'                          | 'Катанка Ст3сп 6,5'                          | 'кг'      | '20,000'      |
				| 'Краска порошковая серая 9006'               | 'Краска порошковая серая 9006'               | 'кг'      | '10,000'      |
				| 'труба электросварная круглая 10х1х5660'     | 'труба электросварная круглая 10х1х5660'     | 'pcs'     | '20,000'      |
				| 'Копыта на стремянки Класс 20х20, черный'    | 'Копыта на стремянки Класс 20х20, черный'    | 'pcs'     | '20,000'      |
				| 'Коврик для стремянок Класс, черный'         | 'Коврик для стремянок Класс, черный'         | 'pcs'     | '10,000'      |
				| 'Копыта на стремянки Класс 30х20, черный'    | 'Копыта на стремянки Класс 30х20, черный'    | 'pcs'     | '20,000'      |
			Then the number of "Materials" table lines is "меньше или равно" "9"
			* Filling material type and writeoff store
				And I go to line in "Materials" table
					| '#'     | '(BOM) Item'                   | '(BOM) Item key'               | '(BOM) Q'     | '(BOM) Unit'     | 'Item'                         | 'Item key'                     | 'Q'           | 'Unit'      |
					| '2'     | 'Скобы 3515 (Упаковочные)'     | 'Скобы 3515 (Упаковочные)'     | '100,000'     | 'pcs'            | 'Скобы 3515 (Упаковочные)'     | 'Скобы 3515 (Упаковочные)'     | '100,000'     | 'pcs'       |
				And I activate "Material type" field in "Materials" table				
				And I select "Material" exact value from "Material type" drop-down list in "Materials" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#'     | '(BOM) Item'                       | '(BOM) Item key'                   | '(BOM) Q'     | '(BOM) Unit'     | 'Item'                             | 'Item key'                         | 'Q'           | 'Unit'      |
					| '1'     | 'Заклепка 6х47 полупустотелая'     | 'Заклепка 6х47 полупустотелая'     | '150,000'     | 'pcs'            | 'Заклепка 6х47 полупустотелая'     | 'Заклепка 6х47 полупустотелая'     | '150,000'     | 'pcs'       |
				And I select current line in "Materials" table
				And I select "Material" exact value from "Material type" drop-down list in "Materials" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#'     | '(BOM) Item'                                  | '(BOM) Item key'                              | '(BOM) Q'     | '(BOM) Unit'     | 'Item'                                        | 'Item key'                                    | 'Q'          | 'Unit'      |
					| '3'     | 'Втулка на стремянки Класс 10 мм, черный'     | 'Втулка на стремянки Класс 10 мм, черный'     | '50,000'      | 'pcs'            | 'Втулка на стремянки Класс 10 мм, черный'     | 'Втулка на стремянки Класс 10 мм, черный'     | '50,000'     | 'pcs'       |
				And I select current line in "Materials" table
				And I select "Material" exact value from "Material type" drop-down list in "Materials" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#'     | '(BOM) Item'            | '(BOM) Item key'        | '(BOM) Q'     | '(BOM) Unit'     | 'Item'                  | 'Item key'              | 'Q'          | 'Unit'      |
					| '4'     | 'Катанка Ст3сп 6,5'     | 'Катанка Ст3сп 6,5'     | '20,000'      | 'кг'             | 'Катанка Ст3сп 6,5'     | 'Катанка Ст3сп 6,5'     | '20,000'     | 'кг'        |
				And I select current line in "Materials" table
				And I select "Material" exact value from "Material type" drop-down list in "Materials" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#'     | '(BOM) Item'                       | '(BOM) Item key'                   | '(BOM) Q'     | '(BOM) Unit'     | 'Item'                             | 'Item key'                         | 'Q'          | 'Unit'      |
					| '5'     | 'Краска порошковая серая 9006'     | 'Краска порошковая серая 9006'     | '10,000'      | 'кг'             | 'Краска порошковая серая 9006'     | 'Краска порошковая серая 9006'     | '10,000'     | 'кг'        |
				And I select current line in "Materials" table
				And I select "Material" exact value from "Material type" drop-down list in "Materials" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#'     | '(BOM) Item'                                 | '(BOM) Item key'                             | '(BOM) Q'     | '(BOM) Unit'     | 'Item'                                       | 'Item key'                                   | 'Q'          | 'Unit'      |
					| '6'     | 'труба электросварная круглая 10х1х5660'     | 'труба электросварная круглая 10х1х5660'     | '20,000'      | 'pcs'            | 'труба электросварная круглая 10х1х5660'     | 'труба электросварная круглая 10х1х5660'     | '20,000'     | 'pcs'       |
				And I select current line in "Materials" table
				And I select "Material" exact value from "Material type" drop-down list in "Materials" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '(BOM) Item'                                  | '(BOM) Item key'                              | 'Item'                                        | 'Q'          | 'Unit'      |
					| 'Копыта на стремянки Класс 20х20, черный'     | 'Копыта на стремянки Класс 20х20, черный'     | 'Копыта на стремянки Класс 20х20, черный'     | '20,000'     | 'pcs'       |
				And I select current line in "Materials" table
				And I select "Material" exact value from "Material type" drop-down list in "Materials" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#'     | '(BOM) Item'                             | '(BOM) Item key'                         | '(BOM) Q'     | '(BOM) Unit'     | 'Item'                                   | 'Item key'                               | 'Q'          | 'Unit'      |
					| '8'     | 'Коврик для стремянок Класс, черный'     | 'Коврик для стремянок Класс, черный'     | '10,000'      | 'pcs'            | 'Коврик для стремянок Класс, черный'     | 'Коврик для стремянок Класс, черный'     | '10,000'     | 'pcs'       |
				And I select current line in "Materials" table
				And I select "Material" exact value from "Material type" drop-down list in "Materials" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '#'     | '(BOM) Item'                                  | '(BOM) Item key'                              | '(BOM) Q'     | '(BOM) Unit'     | 'Item'                                        | 'Item key'                                    | 'Q'          | 'Unit'      |
					| '9'     | 'Копыта на стремянки Класс 30х20, черный'     | 'Копыта на стремянки Класс 30х20, черный'     | '20,000'      | 'pcs'            | 'Копыта на стремянки Класс 30х20, черный'     | 'Копыта на стремянки Класс 30х20, черный'     | '20,000'     | 'pcs'       |
				And I select current line in "Materials" table
				And I select "Material" exact value from "Material type" drop-down list in "Materials" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '(BOM) Item'                        |
					| 'Заклепка 6х47 полупустотелая'      |
				And I activate "Writeoff store" field in "Materials" table
				And I select current line in "Materials" table
				And I click choice button of "Writeoff store" attribute in "Materials" table
				And I go to line in "List" table
					| 'Description'     | 
					| 'Store 05'        | 
				And I select current line in "List" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '(BOM) Item'                    |
					| 'Скобы 3515 (Упаковочные)'      |
				And I select current line in "Materials" table
				And I click choice button of "Writeoff store" attribute in "Materials" table
				And I go to line in "List" table
					| 'Description'     |
					| 'Store 05'        |
				And I select current line in "List" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '(BOM) Item'                                   |
					| 'Втулка на стремянки Класс 10 мм, черный'      |
				And I select current line in "Materials" table
				And I click choice button of "Writeoff store" attribute in "Materials" table
				Then "Stores" window is opened
				And I go to line in "List" table
					| 'Description'      |
					| 'Store 05'         |
				And I select current line in "List" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '(BOM) Item'             |
					| 'Катанка Ст3сп 6,5'      |
				And I select current line in "Materials" table
				And I click choice button of "Writeoff store" attribute in "Materials" table
				Then "Stores" window is opened
				And I go to line in "List" table
					| 'Description'     |
					| 'Store 05'        |
				And I select current line in "List" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '(BOM) Item'                        |
					| 'Краска порошковая серая 9006'      |
				And I select current line in "Materials" table
				And I click choice button of "Writeoff store" attribute in "Materials" table
				And I go to line in "List" table
					| 'Description'      |
					| 'Store 05'         |
				And I select current line in "List" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '(BOM) Item'                                  |
					| 'труба электросварная круглая 10х1х5660'      |
				And I select current line in "Materials" table
				And I click choice button of "Writeoff store" attribute in "Materials" table
				Then "Stores" window is opened
				And I go to line in "List" table
					| 'Description'      |
					| 'Store 05'         |
				And I select current line in "List" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '(BOM) Item'                                   |
					| 'Копыта на стремянки Класс 20х20, черный'      |
				And I select current line in "Materials" table
				And I click choice button of "Writeoff store" attribute in "Materials" table
				Then "Stores" window is opened
				And I go to line in "List" table
					| 'Description'     |
					| 'Store 05'        |
				And I select current line in "List" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '(BOM) Item'                              |
					| 'Коврик для стремянок Класс, черный'      |
				And I select current line in "Materials" table
				And I click choice button of "Writeoff store" attribute in "Materials" table
				Then "Stores" window is opened
				And I go to line in "List" table
					| 'Description'      |
					| 'Store 05'         |
				And I select current line in "List" table
				And I finish line editing in "Materials" table
				And I go to line in "Materials" table
					| '(BOM) Item'                                   |
					| 'Копыта на стремянки Класс 30х20, черный'      |
				And I select current line in "Materials" table
				And I click choice button of "Writeoff store" attribute in "Materials" table
				Then "Stores" window is opened
				And I go to line in "List" table
					| 'Description'      |
					| 'Store 05'         |
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
			And I select "R7010 Detailing supplies" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$Production01$$'                        | ''                        | ''                         | ''                             | ''                           | ''                             | ''                             | ''                                | ''                                | ''                           | ''                               | ''                           | ''                               | ''                | ''                         | ''            | ''                   | ''                                           | ''     |
				| 'Document registrations records'          | ''                        | ''                         | ''                             | ''                           | ''                             | ''                             | ''                                | ''                                | ''                           | ''                               | ''                           | ''                               | ''                | ''                         | ''            | ''                   | ''                                           | ''     |
				| 'Register  "R7010 Detailing supplies"'    | ''                        | ''                         | ''                             | ''                           | ''                             | ''                             | ''                                | ''                                | ''                           | ''                               | ''                           | ''                               | ''                | ''                         | ''            | ''                   | ''                                           | ''     |
				| ''                                        | 'Period'                  | 'Resources'                | ''                             | ''                           | ''                             | ''                             | ''                                | ''                                | ''                           | ''                               | ''                           | ''                               | 'Dimensions'      | ''                         | ''            | ''                   | ''                                           | ''     |
				| ''                                        | ''                        | 'Entry demand quantity'    | 'Corrected demand quantity'    | 'Needed produce quantity'    | 'Produced produce quantity'    | 'Reserved produce quantity'    | 'Written off produce quantity'    | 'Request procurement quantity'    | 'Order transfer quantity'    | 'Confirmed transfer quantity'    | 'Order purchase quantity'    | 'Confirmed purchase quantity'    | 'Company'         | 'Business unit'            | 'Store'       | 'Planning period'    | 'Item key'                                   | ''     |
				| ''                                        | '$$DateProduction01$$'    | ''                         | ''                             | ''                           | ''                             | ''                             | '10'                              | ''                                | ''                           | ''                               | ''                           | ''                               | 'Main Company'    | 'Склад производства 05'    | 'Store 05'    | 'First month'        | 'Краска порошковая серая 9006'               | ''     |
				| ''                                        | '$$DateProduction01$$'    | ''                         | ''                             | ''                           | ''                             | ''                             | '10'                              | ''                                | ''                           | ''                               | ''                           | ''                               | 'Main Company'    | 'Склад производства 05'    | 'Store 05'    | 'First month'        | 'Коврик для стремянок Класс, черный'         | ''     |
				| ''                                        | '$$DateProduction01$$'    | ''                         | ''                             | ''                           | ''                             | ''                             | '20'                              | ''                                | ''                           | ''                               | ''                           | ''                               | 'Main Company'    | 'Склад производства 05'    | 'Store 05'    | 'First month'        | 'Катанка Ст3сп 6,5'                          | ''     |
				| ''                                        | '$$DateProduction01$$'    | ''                         | ''                             | ''                           | ''                             | ''                             | '20'                              | ''                                | ''                           | ''                               | ''                           | ''                               | 'Main Company'    | 'Склад производства 05'    | 'Store 05'    | 'First month'        | 'труба электросварная круглая 10х1х5660'     | ''     |
				| ''                                        | '$$DateProduction01$$'    | ''                         | ''                             | ''                           | ''                             | ''                             | '20'                              | ''                                | ''                           | ''                               | ''                           | ''                               | 'Main Company'    | 'Склад производства 05'    | 'Store 05'    | 'First month'        | 'Копыта на стремянки Класс 20х20, черный'    | ''     |
				| ''                                        | '$$DateProduction01$$'    | ''                         | ''                             | ''                           | ''                             | ''                             | '20'                              | ''                                | ''                           | ''                               | ''                           | ''                               | 'Main Company'    | 'Склад производства 05'    | 'Store 05'    | 'First month'        | 'Копыта на стремянки Класс 30х20, черный'    | ''     |
				| ''                                        | '$$DateProduction01$$'    | ''                         | ''                             | ''                           | ''                             | ''                             | '50'                              | ''                                | ''                           | ''                               | ''                           | ''                               | 'Main Company'    | 'Склад производства 05'    | 'Store 05'    | 'First month'        | 'Втулка на стремянки Класс 10 мм, черный'    | ''     |
				| ''                                        | '$$DateProduction01$$'    | ''                         | ''                             | ''                           | ''                             | ''                             | '100'                             | ''                                | ''                           | ''                               | ''                           | ''                               | 'Main Company'    | 'Склад производства 05'    | 'Store 05'    | 'First month'        | 'Скобы 3515 (Упаковочные)'                   | ''     |
				| ''                                        | '$$DateProduction01$$'    | ''                         | ''                             | ''                           | ''                             | ''                             | '150'                             | ''                                | ''                           | ''                               | ''                           | ''                               | 'Main Company'    | 'Склад производства 05'    | 'Store 05'    | 'First month'        | 'Заклепка 6х47 полупустотелая'               | ''     |
			And I select "R7020 Material planning" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$Production01$$'                       | ''                        | ''             | ''                | ''                                  | ''                         | ''            | ''                                 | ''                                           | ''                 | ''                   | ''                                 | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| 'Document registrations records'         | ''                        | ''             | ''                | ''                                  | ''                         | ''            | ''                                 | ''                                           | ''                 | ''                   | ''                                 | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| 'Register  "R7020 Material planning"'    | ''                        | ''             | ''                | ''                                  | ''                         | ''            | ''                                 | ''                                           | ''                 | ''                   | ''                                 | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | 'Period'                  | 'Resources'    | 'Dimensions'      | ''                                  | ''                         | ''            | ''                                 | ''                                           | ''                 | ''                   | ''                                 | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | ''                        | 'Quantity'     | 'Company'         | 'Planning document'                 | 'Business unit'            | 'Store'       | 'Production'                       | 'Item key'                                   | 'Planning type'    | 'Planning period'    | 'Bill of materials'                | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | '$$DateProduction01$$'    | '10'           | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'Краска порошковая серая 9006'               | 'Produced'         | 'First month'        | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | '$$DateProduction01$$'    | '10'           | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'Коврик для стремянок Класс, черный'         | 'Produced'         | 'First month'        | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | '$$DateProduction01$$'    | '20'           | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'Катанка Ст3сп 6,5'                          | 'Produced'         | 'First month'        | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | '$$DateProduction01$$'    | '20'           | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'труба электросварная круглая 10х1х5660'     | 'Produced'         | 'First month'        | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | '$$DateProduction01$$'    | '20'           | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'Копыта на стремянки Класс 20х20, черный'    | 'Produced'         | 'First month'        | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | '$$DateProduction01$$'    | '20'           | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'Копыта на стремянки Класс 30х20, черный'    | 'Produced'         | 'First month'        | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | '$$DateProduction01$$'    | '50'           | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'Втулка на стремянки Класс 10 мм, черный'    | 'Produced'         | 'First month'        | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | '$$DateProduction01$$'    | '100'          | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'Скобы 3515 (Упаковочные)'                   | 'Produced'         | 'First month'        | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | '$$DateProduction01$$'    | '150'          | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'Заклепка 6х47 полупустотелая'               | 'Produced'         | 'First month'        | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
			And I select "R7030 Production planning" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$Production01$$'                         | ''                        | ''             | ''                | ''                                  | ''                         | ''            | ''                                 | ''                 | ''                   | ''                   | ''                                 | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| 'Document registrations records'           | ''                        | ''             | ''                | ''                                  | ''                         | ''            | ''                                 | ''                 | ''                   | ''                   | ''                                 | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| 'Register  "R7030 Production planning"'    | ''                        | ''             | ''                | ''                                  | ''                         | ''            | ''                                 | ''                 | ''                   | ''                   | ''                                 | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                         | 'Period'                  | 'Resources'    | 'Dimensions'      | ''                                  | ''                         | ''            | ''                                 | ''                 | ''                   | ''                   | ''                                 | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                         | ''                        | 'Quantity'     | 'Company'         | 'Planning document'                 | 'Business unit'            | 'Store'       | 'Item key'                         | 'Planning type'    | 'Planning period'    | 'Production type'    | 'Bill of materials'                | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                         | '$$DateProduction01$$'    | '10'           | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'Produced'         | 'First month'        | 'Product'            | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
			And I select "R7040 Manual materials corretion in production" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| 'Register  "R7040 Manual materials corretion in production"'    | ''                        | ''             | ''                | ''                | ''                         | ''                                 | ''                   | ''                                           | ''                                           | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | 'Period'                  | 'Resources'    | ''                | 'Dimensions'      | ''                         | ''                                 | ''                   | ''                                           | ''                                           | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | ''                        | 'Quantity'     | 'Quantity BOM'    | 'Company'         | 'Business unit'            | 'Bill of materials'                | 'Planning period'    | 'Item key BOM'                               | 'Item key'                                   | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | '$$DateProduction01$$'    | '10'           | '10'              | 'Main Company'    | 'Склад производства 05'    | 'Стремянка номер 6 ступенчатая'    | 'First month'        | 'Краска порошковая серая 9006'               | 'Краска порошковая серая 9006'               | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | '$$DateProduction01$$'    | '10'           | '10'              | 'Main Company'    | 'Склад производства 05'    | 'Стремянка номер 6 ступенчатая'    | 'First month'        | 'Коврик для стремянок Класс, черный'         | 'Коврик для стремянок Класс, черный'         | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | '$$DateProduction01$$'    | '20'           | '20'              | 'Main Company'    | 'Склад производства 05'    | 'Стремянка номер 6 ступенчатая'    | 'First month'        | 'Катанка Ст3сп 6,5'                          | 'Катанка Ст3сп 6,5'                          | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | '$$DateProduction01$$'    | '20'           | '20'              | 'Main Company'    | 'Склад производства 05'    | 'Стремянка номер 6 ступенчатая'    | 'First month'        | 'труба электросварная круглая 10х1х5660'     | 'труба электросварная круглая 10х1х5660'     | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | '$$DateProduction01$$'    | '20'           | '20'              | 'Main Company'    | 'Склад производства 05'    | 'Стремянка номер 6 ступенчатая'    | 'First month'        | 'Копыта на стремянки Класс 20х20, черный'    | 'Копыта на стремянки Класс 20х20, черный'    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | '$$DateProduction01$$'    | '20'           | '20'              | 'Main Company'    | 'Склад производства 05'    | 'Стремянка номер 6 ступенчатая'    | 'First month'        | 'Копыта на стремянки Класс 30х20, черный'    | 'Копыта на стремянки Класс 30х20, черный'    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | '$$DateProduction01$$'    | '50'           | '50'              | 'Main Company'    | 'Склад производства 05'    | 'Стремянка номер 6 ступенчатая'    | 'First month'        | 'Втулка на стремянки Класс 10 мм, черный'    | 'Втулка на стремянки Класс 10 мм, черный'    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | '$$DateProduction01$$'    | '100'          | '100'             | 'Main Company'    | 'Склад производства 05'    | 'Стремянка номер 6 ступенчатая'    | 'First month'        | 'Скобы 3515 (Упаковочные)'                   | 'Скобы 3515 (Упаковочные)'                   | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | '$$DateProduction01$$'    | '150'          | '150'             | 'Main Company'    | 'Склад производства 05'    | 'Стремянка номер 6 ступенчатая'    | 'First month'        | 'Заклепка 6х47 полупустотелая'               | 'Заклепка 6х47 полупустотелая'               | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
			And I select "R4011 Free stocks" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| 'Document registrations records'    | ''               | ''                        | ''             | ''              | ''                                            |
				| 'Register  "R4011 Free stocks"'     | ''               | ''                        | ''             | ''              | ''                                            |
				| ''                                  | 'Record type'    | 'Period'                  | 'Resources'    | 'Dimensions'    | ''                                            |
				| ''                                  | ''               | ''                        | 'Quantity'     | 'Store'         | 'Item key'                                    |
				| ''                                  | 'Receipt'        | '$$DateProduction01$$'    | '10'           | 'Store 05'      | 'Стремянка номер 6 ступенчатая'               |
				| ''                                  | 'Expense'        | '$$DateProduction01$$'    | '10'           | 'Store 05'      | 'Краска порошковая серая 9006'                |
				| ''                                  | 'Expense'        | '$$DateProduction01$$'    | '10'           | 'Store 05'      | 'Коврик для стремянок Класс, черный'          |
				| ''                                  | 'Expense'        | '$$DateProduction01$$'    | '20'           | 'Store 05'      | 'Катанка Ст3сп 6,5'                           |
				| ''                                  | 'Expense'        | '$$DateProduction01$$'    | '20'           | 'Store 05'      | 'труба электросварная круглая 10х1х5660'      |
				| ''                                  | 'Expense'        | '$$DateProduction01$$'    | '20'           | 'Store 05'      | 'Копыта на стремянки Класс 20х20, черный'     |
				| ''                                  | 'Expense'        | '$$DateProduction01$$'    | '20'           | 'Store 05'      | 'Копыта на стремянки Класс 30х20, черный'     |
				| ''                                  | 'Expense'        | '$$DateProduction01$$'    | '50'           | 'Store 05'      | 'Втулка на стремянки Класс 10 мм, черный'     |
				| ''                                  | 'Expense'        | '$$DateProduction01$$'    | '100'          | 'Store 05'      | 'Скобы 3515 (Упаковочные)'                    |
				| ''                                  | 'Expense'        | '$$DateProduction01$$'    | '150'          | 'Store 05'      | 'Заклепка 6х47 полупустотелая'                |
			And I select "R4010 Actual stocks" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| 'Register  "R4010 Actual stocks"'    | ''               | ''                        | ''             | ''              | ''                                           | ''                      |
				| ''                                   | 'Record type'    | 'Period'                  | 'Resources'    | 'Dimensions'    | ''                                           | ''                      |
				| ''                                   | ''               | ''                        | 'Quantity'     | 'Store'         | 'Item key'                                   | 'Serial lot number'     |
				| ''                                   | 'Receipt'        | '$$DateProduction01$$'    | '10'           | 'Store 05'      | 'Стремянка номер 6 ступенчатая'              | ''                      |
				| ''                                   | 'Expense'        | '$$DateProduction01$$'    | '10'           | 'Store 05'      | 'Краска порошковая серая 9006'               | ''                      |
				| ''                                   | 'Expense'        | '$$DateProduction01$$'    | '10'           | 'Store 05'      | 'Коврик для стремянок Класс, черный'         | ''                      |
				| ''                                   | 'Expense'        | '$$DateProduction01$$'    | '20'           | 'Store 05'      | 'Катанка Ст3сп 6,5'                          | ''                      |
				| ''                                   | 'Expense'        | '$$DateProduction01$$'    | '20'           | 'Store 05'      | 'труба электросварная круглая 10х1х5660'     | ''                      |
				| ''                                   | 'Expense'        | '$$DateProduction01$$'    | '20'           | 'Store 05'      | 'Копыта на стремянки Класс 20х20, черный'    | ''                      |
				| ''                                   | 'Expense'        | '$$DateProduction01$$'    | '20'           | 'Store 05'      | 'Копыта на стремянки Класс 30х20, черный'    | ''                      |
				| ''                                   | 'Expense'        | '$$DateProduction01$$'    | '50'           | 'Store 05'      | 'Втулка на стремянки Класс 10 мм, черный'    | ''                      |
				| ''                                   | 'Expense'        | '$$DateProduction01$$'    | '100'          | 'Store 05'      | 'Скобы 3515 (Упаковочные)'                   | ''                      |
				| ''                                   | 'Expense'        | '$$DateProduction01$$'    | '150'          | 'Store 05'      | 'Заклепка 6х47 полупустотелая'               | ''                      |
			And I close all client application windows



		

Scenario: _1036 check Production movements when unpost, re-post document
	* Check movements
			Given I open hyperlink "e1cib/list/Document.Production"
			And I go to line in "List" table
				| 'Number'                     |
				| '$$NumberProduction01$$'     |
			And in the table "List" I click the button named "ListContextMenuUndoPosting"
		* Check that there is no movement on the registers
			Given I open hyperlink "e1cib/list/AccumulationRegister.R7030T_ProductionPlanning"
			And "List" table does not contain lines
				| 'Recorder'             |
				| '$$Production01$$'     |
			Given I open hyperlink "e1cib/list/AccumulationRegister.R4011B_FreeStocks"
			And "List" table does not contain lines
				| 'Recorder'             |
				| '$$Production01$$'     |
			Given I open hyperlink "e1cib/list/AccumulationRegister.R7020T_MaterialPlanning"
			And "List" table does not contain lines
				| 'Recorder'             |
				| '$$Production01$$'     |
			Given I open hyperlink "e1cib/list/AccumulationRegister.R4010B_ActualStocks"
			And "List" table does not contain lines
				| 'Recorder'             |
				| '$$Production01$$'     |
			And I close all client application windows
	* Re-posting the document and checking movements on the registers
		* Posting the document
			Given I open hyperlink "e1cib/list/Document.Production"
			And I go to line in "List" table
			| 'Number'                    |
			| '$$NumberProduction01$$'    |
			And in the table "List" I click the button named "ListContextMenuPost"
		* Check movements
			And I click "Registrations report" button
			And I select "R7010 Detailing supplies" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$Production01$$'                        | ''                        | ''                         | ''                             | ''                           | ''                             | ''                             | ''                                | ''                                | ''                           | ''                               | ''                           | ''                               | ''                | ''                         | ''            | ''                   | ''                                           | ''     |
				| 'Document registrations records'          | ''                        | ''                         | ''                             | ''                           | ''                             | ''                             | ''                                | ''                                | ''                           | ''                               | ''                           | ''                               | ''                | ''                         | ''            | ''                   | ''                                           | ''     |
				| 'Register  "R7010 Detailing supplies"'    | ''                        | ''                         | ''                             | ''                           | ''                             | ''                             | ''                                | ''                                | ''                           | ''                               | ''                           | ''                               | ''                | ''                         | ''            | ''                   | ''                                           | ''     |
				| ''                                        | 'Period'                  | 'Resources'                | ''                             | ''                           | ''                             | ''                             | ''                                | ''                                | ''                           | ''                               | ''                           | ''                               | 'Dimensions'      | ''                         | ''            | ''                   | ''                                           | ''     |
				| ''                                        | ''                        | 'Entry demand quantity'    | 'Corrected demand quantity'    | 'Needed produce quantity'    | 'Produced produce quantity'    | 'Reserved produce quantity'    | 'Written off produce quantity'    | 'Request procurement quantity'    | 'Order transfer quantity'    | 'Confirmed transfer quantity'    | 'Order purchase quantity'    | 'Confirmed purchase quantity'    | 'Company'         | 'Business unit'            | 'Store'       | 'Planning period'    | 'Item key'                                   | ''     |
				| ''                                        | '$$DateProduction01$$'    | ''                         | ''                             | ''                           | ''                             | ''                             | '10'                              | ''                                | ''                           | ''                               | ''                           | ''                               | 'Main Company'    | 'Склад производства 05'    | 'Store 05'    | 'First month'        | 'Краска порошковая серая 9006'               | ''     |
				| ''                                        | '$$DateProduction01$$'    | ''                         | ''                             | ''                           | ''                             | ''                             | '10'                              | ''                                | ''                           | ''                               | ''                           | ''                               | 'Main Company'    | 'Склад производства 05'    | 'Store 05'    | 'First month'        | 'Коврик для стремянок Класс, черный'         | ''     |
				| ''                                        | '$$DateProduction01$$'    | ''                         | ''                             | ''                           | ''                             | ''                             | '20'                              | ''                                | ''                           | ''                               | ''                           | ''                               | 'Main Company'    | 'Склад производства 05'    | 'Store 05'    | 'First month'        | 'Катанка Ст3сп 6,5'                          | ''     |
				| ''                                        | '$$DateProduction01$$'    | ''                         | ''                             | ''                           | ''                             | ''                             | '20'                              | ''                                | ''                           | ''                               | ''                           | ''                               | 'Main Company'    | 'Склад производства 05'    | 'Store 05'    | 'First month'        | 'труба электросварная круглая 10х1х5660'     | ''     |
				| ''                                        | '$$DateProduction01$$'    | ''                         | ''                             | ''                           | ''                             | ''                             | '20'                              | ''                                | ''                           | ''                               | ''                           | ''                               | 'Main Company'    | 'Склад производства 05'    | 'Store 05'    | 'First month'        | 'Копыта на стремянки Класс 20х20, черный'    | ''     |
				| ''                                        | '$$DateProduction01$$'    | ''                         | ''                             | ''                           | ''                             | ''                             | '20'                              | ''                                | ''                           | ''                               | ''                           | ''                               | 'Main Company'    | 'Склад производства 05'    | 'Store 05'    | 'First month'        | 'Копыта на стремянки Класс 30х20, черный'    | ''     |
				| ''                                        | '$$DateProduction01$$'    | ''                         | ''                             | ''                           | ''                             | ''                             | '50'                              | ''                                | ''                           | ''                               | ''                           | ''                               | 'Main Company'    | 'Склад производства 05'    | 'Store 05'    | 'First month'        | 'Втулка на стремянки Класс 10 мм, черный'    | ''     |
				| ''                                        | '$$DateProduction01$$'    | ''                         | ''                             | ''                           | ''                             | ''                             | '100'                             | ''                                | ''                           | ''                               | ''                           | ''                               | 'Main Company'    | 'Склад производства 05'    | 'Store 05'    | 'First month'        | 'Скобы 3515 (Упаковочные)'                   | ''     |
				| ''                                        | '$$DateProduction01$$'    | ''                         | ''                             | ''                           | ''                             | ''                             | '150'                             | ''                                | ''                           | ''                               | ''                           | ''                               | 'Main Company'    | 'Склад производства 05'    | 'Store 05'    | 'First month'        | 'Заклепка 6х47 полупустотелая'               | ''     |
			And I select "R7020 Material planning" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| '$$Production01$$'                       | ''                        | ''             | ''                | ''                                  | ''                         | ''            | ''                                 | ''                                           | ''                 | ''                   | ''                                 | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| 'Document registrations records'         | ''                        | ''             | ''                | ''                                  | ''                         | ''            | ''                                 | ''                                           | ''                 | ''                   | ''                                 | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| 'Register  "R7020 Material planning"'    | ''                        | ''             | ''                | ''                                  | ''                         | ''            | ''                                 | ''                                           | ''                 | ''                   | ''                                 | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | 'Period'                  | 'Resources'    | 'Dimensions'      | ''                                  | ''                         | ''            | ''                                 | ''                                           | ''                 | ''                   | ''                                 | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | ''                        | 'Quantity'     | 'Company'         | 'Planning document'                 | 'Business unit'            | 'Store'       | 'Production'                       | 'Item key'                                   | 'Planning type'    | 'Planning period'    | 'Bill of materials'                | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | '$$DateProduction01$$'    | '10'           | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'Краска порошковая серая 9006'               | 'Produced'         | 'First month'        | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | '$$DateProduction01$$'    | '10'           | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'Коврик для стремянок Класс, черный'         | 'Produced'         | 'First month'        | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | '$$DateProduction01$$'    | '20'           | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'Катанка Ст3сп 6,5'                          | 'Produced'         | 'First month'        | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | '$$DateProduction01$$'    | '20'           | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'труба электросварная круглая 10х1х5660'     | 'Produced'         | 'First month'        | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | '$$DateProduction01$$'    | '20'           | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'Копыта на стремянки Класс 20х20, черный'    | 'Produced'         | 'First month'        | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | '$$DateProduction01$$'    | '20'           | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'Копыта на стремянки Класс 30х20, черный'    | 'Produced'         | 'First month'        | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | '$$DateProduction01$$'    | '50'           | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'Втулка на стремянки Класс 10 мм, черный'    | 'Produced'         | 'First month'        | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | '$$DateProduction01$$'    | '100'          | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'Скобы 3515 (Упаковочные)'                   | 'Produced'         | 'First month'        | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                       | '$$DateProduction01$$'    | '150'          | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'Заклепка 6х47 полупустотелая'               | 'Produced'         | 'First month'        | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
			And I select "R7030 Production planning" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:	
				| '$$Production01$$'                         | ''                        | ''             | ''                | ''                                  | ''                         | ''            | ''                                 | ''                 | ''                   | ''                   | ''                                 | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| 'Document registrations records'           | ''                        | ''             | ''                | ''                                  | ''                         | ''            | ''                                 | ''                 | ''                   | ''                   | ''                                 | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| 'Register  "R7030 Production planning"'    | ''                        | ''             | ''                | ''                                  | ''                         | ''            | ''                                 | ''                 | ''                   | ''                   | ''                                 | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                         | 'Period'                  | 'Resources'    | 'Dimensions'      | ''                                  | ''                         | ''            | ''                                 | ''                 | ''                   | ''                   | ''                                 | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                         | ''                        | 'Quantity'     | 'Company'         | 'Planning document'                 | 'Business unit'            | 'Store'       | 'Item key'                         | 'Planning type'    | 'Planning period'    | 'Production type'    | 'Bill of materials'                | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                         | '$$DateProduction01$$'    | '10'           | 'Main Company'    | '$$ProductionPlanning01103110$$'    | 'Склад производства 05'    | 'Store 05'    | 'Стремянка номер 6 ступенчатая'    | 'Produced'         | 'First month'        | 'Product'            | 'Стремянка номер 6 ступенчатая'    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
			And I select "R7040 Manual materials corretion in production" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:	
				| '$$Production01$$'                                              | ''                        | ''             | ''                | ''                | ''                         | ''                                 | ''                   | ''                                           | ''                                           | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| 'Document registrations records'                                | ''                        | ''             | ''                | ''                | ''                         | ''                                 | ''                   | ''                                           | ''                                           | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| 'Register  "R7040 Manual materials corretion in production"'    | ''                        | ''             | ''                | ''                | ''                         | ''                                 | ''                   | ''                                           | ''                                           | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | 'Period'                  | 'Resources'    | ''                | 'Dimensions'      | ''                         | ''                                 | ''                   | ''                                           | ''                                           | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | ''                        | 'Quantity'     | 'Quantity BOM'    | 'Company'         | 'Business unit'            | 'Bill of materials'                | 'Planning period'    | 'Item key BOM'                               | 'Item key'                                   | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | '$$DateProduction01$$'    | '10'           | '10'              | 'Main Company'    | 'Склад производства 05'    | 'Стремянка номер 6 ступенчатая'    | 'First month'        | 'Краска порошковая серая 9006'               | 'Краска порошковая серая 9006'               | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | '$$DateProduction01$$'    | '10'           | '10'              | 'Main Company'    | 'Склад производства 05'    | 'Стремянка номер 6 ступенчатая'    | 'First month'        | 'Коврик для стремянок Класс, черный'         | 'Коврик для стремянок Класс, черный'         | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | '$$DateProduction01$$'    | '20'           | '20'              | 'Main Company'    | 'Склад производства 05'    | 'Стремянка номер 6 ступенчатая'    | 'First month'        | 'Катанка Ст3сп 6,5'                          | 'Катанка Ст3сп 6,5'                          | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | '$$DateProduction01$$'    | '20'           | '20'              | 'Main Company'    | 'Склад производства 05'    | 'Стремянка номер 6 ступенчатая'    | 'First month'        | 'труба электросварная круглая 10х1х5660'     | 'труба электросварная круглая 10х1х5660'     | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | '$$DateProduction01$$'    | '20'           | '20'              | 'Main Company'    | 'Склад производства 05'    | 'Стремянка номер 6 ступенчатая'    | 'First month'        | 'Копыта на стремянки Класс 20х20, черный'    | 'Копыта на стремянки Класс 20х20, черный'    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | '$$DateProduction01$$'    | '20'           | '20'              | 'Main Company'    | 'Склад производства 05'    | 'Стремянка номер 6 ступенчатая'    | 'First month'        | 'Копыта на стремянки Класс 30х20, черный'    | 'Копыта на стремянки Класс 30х20, черный'    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | '$$DateProduction01$$'    | '50'           | '50'              | 'Main Company'    | 'Склад производства 05'    | 'Стремянка номер 6 ступенчатая'    | 'First month'        | 'Втулка на стремянки Класс 10 мм, черный'    | 'Втулка на стремянки Класс 10 мм, черный'    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | '$$DateProduction01$$'    | '100'          | '100'             | 'Main Company'    | 'Склад производства 05'    | 'Стремянка номер 6 ступенчатая'    | 'First month'        | 'Скобы 3515 (Упаковочные)'                   | 'Скобы 3515 (Упаковочные)'                   | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
				| ''                                                              | '$$DateProduction01$$'    | '150'          | '150'             | 'Main Company'    | 'Склад производства 05'    | 'Стремянка номер 6 ступенчатая'    | 'First month'        | 'Заклепка 6х47 полупустотелая'               | 'Заклепка 6х47 полупустотелая'               | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''    | ''     |
			And I select "R4011 Free stocks" exact value from "Register" drop-down list
			And I click "Generate report" button
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| 'Document registrations records'    | ''               | ''                        | ''             | ''              | ''                                            |
				| 'Register  "R4011 Free stocks"'     | ''               | ''                        | ''             | ''              | ''                                            |
				| ''                                  | 'Record type'    | 'Period'                  | 'Resources'    | 'Dimensions'    | ''                                            |
				| ''                                  | ''               | ''                        | 'Quantity'     | 'Store'         | 'Item key'                                    |
				| ''                                  | 'Receipt'        | '$$DateProduction01$$'    | '10'           | 'Store 05'      | 'Стремянка номер 6 ступенчатая'               |
				| ''                                  | 'Expense'        | '$$DateProduction01$$'    | '10'           | 'Store 05'      | 'Краска порошковая серая 9006'                |
				| ''                                  | 'Expense'        | '$$DateProduction01$$'    | '10'           | 'Store 05'      | 'Коврик для стремянок Класс, черный'          |
				| ''                                  | 'Expense'        | '$$DateProduction01$$'    | '20'           | 'Store 05'      | 'Катанка Ст3сп 6,5'                           |
				| ''                                  | 'Expense'        | '$$DateProduction01$$'    | '20'           | 'Store 05'      | 'труба электросварная круглая 10х1х5660'      |
				| ''                                  | 'Expense'        | '$$DateProduction01$$'    | '20'           | 'Store 05'      | 'Копыта на стремянки Класс 20х20, черный'     |
				| ''                                  | 'Expense'        | '$$DateProduction01$$'    | '20'           | 'Store 05'      | 'Копыта на стремянки Класс 30х20, черный'     |
				| ''                                  | 'Expense'        | '$$DateProduction01$$'    | '50'           | 'Store 05'      | 'Втулка на стремянки Класс 10 мм, черный'     |
				| ''                                  | 'Expense'        | '$$DateProduction01$$'    | '100'          | 'Store 05'      | 'Скобы 3515 (Упаковочные)'                    |
				| ''                                  | 'Expense'        | '$$DateProduction01$$'    | '150'          | 'Store 05'      | 'Заклепка 6х47 полупустотелая'                |
			And I select "R4010 Actual stocks" exact value from "Register" drop-down list
			And I click "Generate report" button
			And "ResultTable" spreadsheet document contains lines:
				| 'Register  "R4010 Actual stocks"'    | ''               | ''                        | ''             | ''              | ''                                           | ''                      |
				| ''                                   | 'Record type'    | 'Period'                  | 'Resources'    | 'Dimensions'    | ''                                           | ''                      |
				| ''                                   | ''               | ''                        | 'Quantity'     | 'Store'         | 'Item key'                                   | 'Serial lot number'     |
				| ''                                   | 'Receipt'        | '$$DateProduction01$$'    | '10'           | 'Store 05'      | 'Стремянка номер 6 ступенчатая'              | ''                      |
				| ''                                   | 'Expense'        | '$$DateProduction01$$'    | '10'           | 'Store 05'      | 'Краска порошковая серая 9006'               | ''                      |
				| ''                                   | 'Expense'        | '$$DateProduction01$$'    | '10'           | 'Store 05'      | 'Коврик для стремянок Класс, черный'         | ''                      |
				| ''                                   | 'Expense'        | '$$DateProduction01$$'    | '20'           | 'Store 05'      | 'Катанка Ст3сп 6,5'                          | ''                      |
				| ''                                   | 'Expense'        | '$$DateProduction01$$'    | '20'           | 'Store 05'      | 'труба электросварная круглая 10х1х5660'     | ''                      |
				| ''                                   | 'Expense'        | '$$DateProduction01$$'    | '20'           | 'Store 05'      | 'Копыта на стремянки Класс 20х20, черный'    | ''                      |
				| ''                                   | 'Expense'        | '$$DateProduction01$$'    | '20'           | 'Store 05'      | 'Копыта на стремянки Класс 30х20, черный'    | ''                      |
				| ''                                   | 'Expense'        | '$$DateProduction01$$'    | '50'           | 'Store 05'      | 'Втулка на стремянки Класс 10 мм, черный'    | ''                      |
				| ''                                   | 'Expense'        | '$$DateProduction01$$'    | '100'          | 'Store 05'      | 'Скобы 3515 (Упаковочные)'                   | ''                      |
				| ''                                   | 'Expense'        | '$$DateProduction01$$'    | '150'          | 'Store 05'      | 'Заклепка 6х47 полупустотелая'               | ''                      |
			And I close all client application windows

			

Scenario: _1037 create document Production based on production planning
	* Select ProductionPlanning
		Given I open hyperlink "e1cib/list/Document.ProductionPlanning"
		And I go to line in "List" table
			| 'Number'                                  |
			| '$$NumberProductionPlanning01103110$$'    |
	* Create document Production based on production planning
		And I click "Production" button
		And I go to line in "ProductionTable" table
			| 'Bill of materials'               | 'Production'                                                     | 'Q'        | 'Selected'   | 'Unit'    |
			| 'Стремянка номер 6 ступенчатая'   | 'Стремянка номер 6 ступенчатая, Стремянка номер 6 ступенчатая'   | '90,000'   | 'No'         | 'pcs'     |
		And I change "Selected" checkbox in "ProductionTable" table
		And I finish line editing in "ProductionTable" table
		And I click "Ok" button
	* Check filling 
		Then the form attribute named "DecorationClosingOrder" became equal to "This planning period is closed by:"
		Then the form attribute named "ProductionPlanningClosing" became equal to ""
		Then the form attribute named "DecorationGroupTitleCollapsedPicture" became equal to "Decoration group title collapsed picture"
		Then the form attribute named "DecorationGroupTitleCollapsedLabel" became equal to "Company: Main Company   Business unit: Склад производства 05   Store production: Store 01   Posting status: New   "
		Then the form attribute named "DecorationGroupTitleUncollapsedPicture" became equal to "DecorationGroupTitleUncollapsedPicture"
		Then the form attribute named "DecorationGroupTitleUncollapsedLabel" became equal to "Company: Main Company   Business unit: Склад производства 05   Store production: Store 01   Posting status: New   "
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "BusinessUnit" became equal to "Склад производства 05"
		Then the form attribute named "Description" became equal to "Click to enter description"
		Then the form attribute named "PlanningPeriod" became equal to "First month"
		Then the form attribute named "Item" became equal to "Стремянка номер 6 ступенчатая"
		Then the form attribute named "ItemKey" became equal to "Стремянка номер 6 ступенчатая"
		Then the form attribute named "BillOfMaterials" became equal to "Стремянка номер 6 ступенчатая"
		Then the form attribute named "Unit" became equal to "pcs"
		Then the form attribute named "Branch" became equal to "Цех 07"		
		Then the form attribute named "StoreProduction" became equal to "Store 01"		
		And the editing text of form attribute named "Quantity" became equal to "90,000"
		And I move to "Materials" tab
		And "Materials" table contains lines
			| '(BOM) Item'                                | '(BOM) Item key'                            | '(BOM) Unit'   | '(BOM) Q'     | 'Item'                                      | 'Item key'                                  | 'Unit'   | 'Q'           | 'Material type'   | 'Writeoff store'    |
			| 'Заклепка 6х47 полупустотелая'              | 'Заклепка 6х47 полупустотелая'              | 'pcs'          | '1 350,000'   | 'Заклепка 6х47 полупустотелая'              | 'Заклепка 6х47 полупустотелая'              | 'pcs'    | '1 350,000'   | 'Material'        | 'Store 04'          |
			| 'Катанка Ст3сп 6,5'                         | 'Катанка Ст3сп 6,5'                         | 'кг'           | '180,000'     | 'Катанка Ст3сп 6,5'                         | 'Катанка Ст3сп 6,5'                         | 'кг'     | '180,000'     | 'Material'        | 'Store 07'          |
			| 'Краска порошковая серая 9006'              | 'Краска порошковая серая 9006'              | 'кг'           | '90,000'      | 'Краска порошковая серая 9006'              | 'Краска порошковая серая 9006'              | 'кг'     | '90,000'      | 'Material'        | 'Store 07'          |
			| 'труба электросварная круглая 10х1х5660'    | 'труба электросварная круглая 10х1х5660'    | 'pcs'          | '180,000'     | 'труба электросварная круглая 10х1х5660'    | 'труба электросварная круглая 10х1х5660'    | 'pcs'    | '180,000'     | 'Material'        | 'Store 07'          |
			| 'Копыта на стремянки Класс 20х20, черный'   | 'Копыта на стремянки Класс 20х20, черный'   | 'pcs'          | '180,000'     | 'Копыта на стремянки Класс 20х20, черный'   | 'Копыта на стремянки Класс 20х20, черный'   | 'pcs'    | '180,000'     | 'Semiproduct'     | 'Store 04'          |
			| 'Копыта на стремянки Класс 30х20, черный'   | 'Копыта на стремянки Класс 30х20, черный'   | 'pcs'          | '180,000'     | 'Копыта на стремянки Класс 30х20, черный'   | 'Копыта на стремянки Класс 30х20, черный'   | 'pcs'    | '180,000'     | 'Semiproduct'     | 'Store 04'          |
			| 'Втулка на стремянки Класс 10 мм, черный'   | 'Втулка на стремянки Класс 10 мм, черный'   | 'pcs'          | '450,000'     | 'Втулка на стремянки Класс 10 мм, черный'   | 'Втулка на стремянки Класс 10 мм, черный'   | 'pcs'    | '450,000'     | 'Material'        | 'Store 07'          |
			| 'Коврик для стремянок Класс, черный'        | 'Коврик для стремянок Класс, черный'        | 'pcs'          | '90,000'      | 'Коврик для стремянок Класс, черный'        | 'Коврик для стремянок Класс, черный'        | 'pcs'    | '90,000'      | 'Material'        | 'Store 07'          |
			| 'Скобы 3515 (Упаковочные)'                  | 'Скобы 3515 (Упаковочные)'                  | 'pcs'          | '900,000'     | 'Скобы 3515 (Упаковочные)'                  | 'Скобы 3515 (Упаковочные)'                  | 'pcs'    | '900,000'     | 'Material'        | 'Store 07'          |
		Then the number of "Materials" table lines is "равно" "9"		
		Then the form attribute named "ProductionType" became equal to "Product"
		Then the form attribute named "Finished" became equal to "No"
		Then the form attribute named "Author" became equal to "CI"
	* Change Q and add new item
		And I activate field named "MaterialsQuantity" in "Materials" table
		And I go to line in "Materials" table
			| 'Item'                                 | 'Item key'                             | 'Q'        | 'Unit'    |
			| 'Коврик для стремянок Класс, черный'   | 'Коврик для стремянок Класс, черный'   | '90,000'   | 'pcs'     |
		And I select current line in "Materials" table
		And I input "89,000" text in the field named "MaterialsQuantity" of "Materials" table
		And I finish line editing in "Materials" table
		And in the table "Materials" I click the button named "MaterialsAdd"
		And I click choice button of the attribute named "MaterialsItem" in "Materials" table
		And I go to line in "List" table
			| 'Description'   |
			| 'Упаковка 01'   |
		And I select current line in "List" table
		And I input "1,000" text in the field named "MaterialsQuantity" of "Materials" table
		And I select "Material" exact value from "Material type" drop-down list in "Materials" table
		And I activate "Writeoff store" field in "Materials" table
		And I click choice button of "Writeoff store" attribute in "Materials" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 04'       |
		And I select current line in "List" table				
		And I finish line editing in "Materials" table
		And "Materials" table contains lines
			| '(BOM) Item'                                | '(BOM) Item key'                            | '(BOM) Unit'   | '(BOM) Q'     | 'Item'                                      | 'Item key'                                  | 'Unit'   | 'Q'           | 'Material type'   | 'Writeoff store'    |
			| 'Заклепка 6х47 полупустотелая'              | 'Заклепка 6х47 полупустотелая'              | 'pcs'          | '1 350,000'   | 'Заклепка 6х47 полупустотелая'              | 'Заклепка 6х47 полупустотелая'              | 'pcs'    | '1 350,000'   | 'Material'        | 'Store 04'          |
			| 'Катанка Ст3сп 6,5'                         | 'Катанка Ст3сп 6,5'                         | 'кг'           | '180,000'     | 'Катанка Ст3сп 6,5'                         | 'Катанка Ст3сп 6,5'                         | 'кг'     | '180,000'     | 'Material'        | 'Store 07'          |
			| 'Краска порошковая серая 9006'              | 'Краска порошковая серая 9006'              | 'кг'           | '90,000'      | 'Краска порошковая серая 9006'              | 'Краска порошковая серая 9006'              | 'кг'     | '90,000'      | 'Material'        | 'Store 07'          |
			| 'труба электросварная круглая 10х1х5660'    | 'труба электросварная круглая 10х1х5660'    | 'pcs'          | '180,000'     | 'труба электросварная круглая 10х1х5660'    | 'труба электросварная круглая 10х1х5660'    | 'pcs'    | '180,000'     | 'Material'        | 'Store 07'          |
			| 'Копыта на стремянки Класс 20х20, черный'   | 'Копыта на стремянки Класс 20х20, черный'   | 'pcs'          | '180,000'     | 'Копыта на стремянки Класс 20х20, черный'   | 'Копыта на стремянки Класс 20х20, черный'   | 'pcs'    | '180,000'     | 'Semiproduct'     | 'Store 04'          |
			| 'Копыта на стремянки Класс 30х20, черный'   | 'Копыта на стремянки Класс 30х20, черный'   | 'pcs'          | '180,000'     | 'Копыта на стремянки Класс 30х20, черный'   | 'Копыта на стремянки Класс 30х20, черный'   | 'pcs'    | '180,000'     | 'Semiproduct'     | 'Store 04'          |
			| 'Втулка на стремянки Класс 10 мм, черный'   | 'Втулка на стремянки Класс 10 мм, черный'   | 'pcs'          | '450,000'     | 'Втулка на стремянки Класс 10 мм, черный'   | 'Втулка на стремянки Класс 10 мм, черный'   | 'pcs'    | '450,000'     | 'Material'        | 'Store 07'          |
			| 'Коврик для стремянок Класс, черный'        | 'Коврик для стремянок Класс, черный'        | 'pcs'          | '90,000'      | 'Коврик для стремянок Класс, черный'        | 'Коврик для стремянок Класс, черный'        | 'pcs'    | '89,000'      | 'Material'        | 'Store 07'          |
			| 'Скобы 3515 (Упаковочные)'                  | 'Скобы 3515 (Упаковочные)'                  | 'pcs'          | '900,000'     | 'Скобы 3515 (Упаковочные)'                  | 'Скобы 3515 (Упаковочные)'                  | 'pcs'    | '900,000'     | 'Material'        | 'Store 07'          |
			| ''                                          | ''                                          | ''             | ''            | 'Упаковка 01'                               | '*'                                         | 'pcs'    | '1,000'       | 'Material'        | 'Store 04'          |
		Then the number of "Materials" table lines is "равно" "10"		
	And I close all client application windows





Scenario: _1040 refilling document Production when change specification
	Given I open hyperlink "e1cib/list/Document.Production"
	And I click the button named "FormCreate"
	* Filling in header info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description'              |
			| 'Склад производства 05'    |
		And I select current line in "List" table
		Then the form attribute named "ProductionPlanning" became equal to "$$ProductionPlanning01103110$$"			
	* Filling in production tab
		And I click Choice button of the field named "Item"
		And I go to line in "List" table
			| 'Description'          |
			| 'Стремянка номер 8'    |
		And I select current line in "List" table
		Then the form attribute named "ItemKey" became equal to "Стремянка номер 8"
	* Select Bill of materials
		And I click Select button of "Bill of materials" field
		And I go to line in "List" table
			| 'Description'                    |
			| 'Стремянка номер 8 (премиум)'    |
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
			| 'Description'                     |
			| 'Стремянка номер 8 (основная)'    |
		And I select current line in "List" table
	* Check material tab
		And "Materials" table contains lines
			| '#'   | '(BOM) Item'                                | '(BOM) Item key'                            | '(BOM) Unit'   | '(BOM) Q'   | 'Item'                                      | 'Item key'                                  | 'Unit'   | 'Q'         |
			| '1'   | 'Заклепка 6х47 полупустотелая'              | 'Заклепка 6х47 полупустотелая'              | 'pcs'          | '20,000'    | 'Заклепка 6х47 полупустотелая'              | 'Заклепка 6х47 полупустотелая'              | 'pcs'    | '21,000'    |
			| '2'   | 'Скобы 3515 (Упаковочные)'                  | 'Скобы 3515 (Упаковочные)'                  | 'pcs'          | '20,000'    | 'Скобы 3515 (Упаковочные)'                  | 'Скобы 3515 (Упаковочные)'                  | 'pcs'    | '20,000'    |
			| '3'   | 'Втулка на стремянки Класс 10 мм, черный'   | 'Втулка на стремянки Класс 10 мм, черный'   | 'pcs'          | '10,000'    | 'Втулка на стремянки Класс 10 мм, черный'   | 'Втулка на стремянки Класс 10 мм, черный'   | 'pcs'    | '10,000'    |
			| '4'   | 'Катанка Ст3сп 6,5'                         | 'Катанка Ст3сп 6,5'                         | 'кг'           | '4,000'     | 'Катанка Ст3сп 6,5'                         | 'Катанка Ст3сп 6,5'                         | 'кг'     | '4,000'     |
			| '5'   | 'труба электросварная круглая 10х1х5660'    | 'труба электросварная круглая 10х1х5660'    | 'pcs'          | '4,000'     | 'труба электросварная круглая 10х1х5660'    | 'труба электросварная круглая 10х1х5660'    | 'pcs'    | '4,000'     |
			| '6'   | 'Копыта на стремянки Класс 20х20, черный'   | 'Копыта на стремянки Класс 20х20, черный'   | 'pcs'          | '4,000'     | 'Копыта на стремянки Класс 20х20, черный'   | 'Копыта на стремянки Класс 20х20, черный'   | 'pcs'    | '4,000'     |
			| '7'   | 'Копыта на стремянки Класс 30х20, черный'   | 'Копыта на стремянки Класс 30х20, черный'   | 'pcs'          | '4,000'     | 'Копыта на стремянки Класс 30х20, черный'   | 'Копыта на стремянки Класс 30х20, черный'   | 'pcs'    | '4,000'     |
		And I go to line in "Materials" table
			| '#'   | 'Item'                                 | 'Item key'                             | 'Q'       | 'Unit'    |
			| '8'   | 'Коврик для стремянок Класс, черный'   | 'Коврик для стремянок Класс, черный'   | '2,000'   | 'pcs'     |
		And in the table "Materials" I click "Delete" button
		And I click "Post" button
	* Change quantity and check material tab
		And I move to "Production" tab
		And I input "4,000" text in "Q" field
		And I move to "Materials" tab
		And "Materials" table became equal
			| '#'   | '(BOM) Item'                                | '(BOM) Item key'                            | '(BOM) Unit'   | '(BOM) Q'   | 'Item'                                      | 'Item key'                                  | 'Unit'   | 'Q'         |
			| '1'   | 'Заклепка 6х47 полупустотелая'              | 'Заклепка 6х47 полупустотелая'              | 'pcs'          | '40,000'    | 'Заклепка 6х47 полупустотелая'              | 'Заклепка 6х47 полупустотелая'              | 'pcs'    | '21,000'    |
			| '2'   | 'Скобы 3515 (Упаковочные)'                  | 'Скобы 3515 (Упаковочные)'                  | 'pcs'          | '40,000'    | 'Скобы 3515 (Упаковочные)'                  | 'Скобы 3515 (Упаковочные)'                  | 'pcs'    | '40,000'    |
			| '3'   | 'Втулка на стремянки Класс 10 мм, черный'   | 'Втулка на стремянки Класс 10 мм, черный'   | 'pcs'          | '20,000'    | 'Втулка на стремянки Класс 10 мм, черный'   | 'Втулка на стремянки Класс 10 мм, черный'   | 'pcs'    | '20,000'    |
			| '4'   | 'Катанка Ст3сп 6,5'                         | 'Катанка Ст3сп 6,5'                         | 'кг'           | '8,000'     | 'Катанка Ст3сп 6,5'                         | 'Катанка Ст3сп 6,5'                         | 'кг'     | '8,000'     |
			| '5'   | 'труба электросварная круглая 10х1х5660'    | 'труба электросварная круглая 10х1х5660'    | 'pcs'          | '8,000'     | 'труба электросварная круглая 10х1х5660'    | 'труба электросварная круглая 10х1х5660'    | 'pcs'    | '8,000'     |
			| '6'   | 'Копыта на стремянки Класс 20х20, черный'   | 'Копыта на стремянки Класс 20х20, черный'   | 'pcs'          | '8,000'     | 'Копыта на стремянки Класс 20х20, черный'   | 'Копыта на стремянки Класс 20х20, черный'   | 'pcs'    | '8,000'     |
			| '7'   | 'Копыта на стремянки Класс 30х20, черный'   | 'Копыта на стремянки Класс 30х20, черный'   | 'pcs'          | '8,000'     | 'Копыта на стремянки Класс 30х20, черный'   | 'Копыта на стремянки Класс 30х20, черный'   | 'pcs'    | '8,000'     |
		* Filling material type and wtiteoff store
			And I activate "Material type" field in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                       |
				| 'Заклепка 6х47 полупустотелая'     |
			And I select current line in "Materials" table
			And I select "Material" exact value from "Material type" drop-down list in "Materials" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                   |
				| 'Скобы 3515 (Упаковочные)'     |
			And I select current line in "Materials" table
			And I select "Material" exact value from "Material type" drop-down list in "Materials" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                                  |
				| 'Втулка на стремянки Класс 10 мм, черный'     |
			And I select current line in "Materials" table
			And I select "Material" exact value from "Material type" drop-down list in "Materials" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'            |
				| 'Катанка Ст3сп 6,5'     |
			And I select current line in "Materials" table
			And I select "Material" exact value from "Material type" drop-down list in "Materials" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                                 |
				| 'труба электросварная круглая 10х1х5660'     |
			And I select current line in "Materials" table
			And I select "Material" exact value from "Material type" drop-down list in "Materials" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                                  |
				| 'Копыта на стремянки Класс 20х20, черный'     |
			And I select current line in "Materials" table
			And I select "Semiproduct" exact value from "Material type" drop-down list in "Materials" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                                  |
				| 'Копыта на стремянки Класс 30х20, черный'     |
			And I select current line in "Materials" table
			And I select "Semiproduct" exact value from "Material type" drop-down list in "Materials" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                       |
				| 'Заклепка 6х47 полупустотелая'     |
			And I activate "Writeoff store" field in "Materials" table
			And I select current line in "Materials" table
			And I click choice button of "Writeoff store" attribute in "Materials" table
			And I go to line in "List" table
				| 'Description'    |
				| 'Store 05'       |
			And I select current line in "List" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                   |
				| 'Скобы 3515 (Упаковочные)'     |
			And I select current line in "Materials" table
			And I click choice button of "Writeoff store" attribute in "Materials" table
			And I go to line in "List" table
				| 'Description'    |
				| 'Store 05'       |
			And I select current line in "List" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                                  |
				| 'Втулка на стремянки Класс 10 мм, черный'     |
			And I select current line in "Materials" table
			And I click choice button of "Writeoff store" attribute in "Materials" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 05'        |
			And I select current line in "List" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'            |
				| 'Катанка Ст3сп 6,5'     |
			And I select current line in "Materials" table
			And I click choice button of "Writeoff store" attribute in "Materials" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 05'        |
			And I select current line in "List" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                                 |
				| 'труба электросварная круглая 10х1х5660'     |
			And I select current line in "Materials" table
			And I click choice button of "Writeoff store" attribute in "Materials" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 05'        |
			And I select current line in "List" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                                  |
				| 'Копыта на стремянки Класс 20х20, черный'     |
			And I select current line in "Materials" table
			And I click choice button of "Writeoff store" attribute in "Materials" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 04'        |
			And I select current line in "List" table
			And I finish line editing in "Materials" table
			And I go to line in "Materials" table
				| '(BOM) Item'                                  |
				| 'Копыта на стремянки Класс 30х20, черный'     |
			And I select current line in "Materials" table
			And I click choice button of "Writeoff store" attribute in "Materials" table
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 04'        |
			And I select current line in "List" table
			And I finish line editing in "Materials" table	
			And I move to "Production" tab
			And I click Select button of "Store production" field
			And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
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
			| '$$Production1040$$'                                           | ''                         | ''            | ''               | ''               | ''                        | ''                               | ''                  | ''                                          | ''                                           |
			| 'Document registrations records'                               | ''                         | ''            | ''               | ''               | ''                        | ''                               | ''                  | ''                                          | ''                                           |
			| 'Register  "R7040 Manual materials corretion in production"'   | ''                         | ''            | ''               | ''               | ''                        | ''                               | ''                  | ''                                          | ''                                           |
			| ''                                                             | 'Period'                   | 'Resources'   | ''               | 'Dimensions'     | ''                        | ''                               | ''                  | ''                                          | ''                                           |
			| ''                                                             | ''                         | 'Quantity'    | 'Quantity BOM'   | 'Company'        | 'Business unit'           | 'Bill of materials'              | 'Planning period'   | 'Item key BOM'                              | 'Item key'                                   |
			| ''                                                             | '$$DateProduction1040$$'   | '8'           | '8'              | 'Main Company'   | 'Склад производства 05'   | 'Стремянка номер 8 (основная)'   | 'First month'       | 'Катанка Ст3сп 6,5'                         | 'Катанка Ст3сп 6,5'                          |
			| ''                                                             | '$$DateProduction1040$$'   | '8'           | '8'              | 'Main Company'   | 'Склад производства 05'   | 'Стремянка номер 8 (основная)'   | 'First month'       | 'труба электросварная круглая 10х1х5660'    | 'труба электросварная круглая 10х1х5660'     |
			| ''                                                             | '$$DateProduction1040$$'   | '8'           | '8'              | 'Main Company'   | 'Склад производства 05'   | 'Стремянка номер 8 (основная)'   | 'First month'       | 'Копыта на стремянки Класс 20х20, черный'   | 'Копыта на стремянки Класс 20х20, черный'    |
			| ''                                                             | '$$DateProduction1040$$'   | '8'           | '8'              | 'Main Company'   | 'Склад производства 05'   | 'Стремянка номер 8 (основная)'   | 'First month'       | 'Копыта на стремянки Класс 30х20, черный'   | 'Копыта на стремянки Класс 30х20, черный'    |
			| ''                                                             | '$$DateProduction1040$$'   | '20'          | '20'             | 'Main Company'   | 'Склад производства 05'   | 'Стремянка номер 8 (основная)'   | 'First month'       | 'Втулка на стремянки Класс 10 мм, черный'   | 'Втулка на стремянки Класс 10 мм, черный'    |
			| ''                                                             | '$$DateProduction1040$$'   | '21'          | '40'             | 'Main Company'   | 'Склад производства 05'   | 'Стремянка номер 8 (основная)'   | 'First month'       | 'Заклепка 6х47 полупустотелая'              | 'Заклепка 6х47 полупустотелая'               |
			| ''                                                             | '$$DateProduction1040$$'   | '40'          | '40'             | 'Main Company'   | 'Склад производства 05'   | 'Стремянка номер 8 (основная)'   | 'First month'       | 'Скобы 3515 (Упаковочные)'                  | 'Скобы 3515 (Упаковочные)'                   |
		And I close all client application windows

Scenario: _10341 create Production (Repacking)
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Production"
	And I click the button named "FormCreate"
	And I select "Repacking" exact value from "Transaction type" drop-down list	
	* Filling in header info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description'              |
			| 'Склад производства 05'    |
		And I select current line in "List" table 
		And I click Select button of "Store production" field
		And I go to line in "List" table
			| 'Company'                    | 'Description'   |
			| 'Shared for all companies'   | 'Store 02'      |
		And I select current line in "List" table
		And I click Choice button of the field named "Item"
		And I select current line in "List" table
		And I input "2,000" text in the field named "Quantity"
	* Filling materials
		And I move to "Materials" tab
		And in the table "Materials" I click the button named "MaterialsAdd"
		And I activate field named "MaterialsItem" in "Materials" table
		And I select current line in "Materials" table
		And I click choice button of the attribute named "MaterialsItem" in "Materials" table
		And I go to line in "List" table
			| 'Description'         |
			| 'Стремянка номер 8'   |
		And I select current line in "List" table
		And I activate "Material type" field in "Materials" table
		And I select "Material" exact value from "Material type" drop-down list in "Materials" table
		And I activate field named "MaterialsQuantity" in "Materials" table
		And I input "2,000" text in the field named "MaterialsQuantity" of "Materials" table
		And I finish line editing in "Materials" table
		And I activate "Writeoff store" field in "Materials" table
		And I select current line in "Materials" table
		And I click choice button of "Writeoff store" attribute in "Materials" table
		And I go to line in "List" table
			| 'Company'                    | 'Description'   |
			| 'Shared for all companies'   | 'Store 03'      |
		And I select current line in "List" table
		And I finish line editing in "Materials" table
		And I click "Post" button
	* Check creation
		And I delete "$$DateProduction1041$$" variable
		And I delete "$$Production1041$$" variable
		And I delete "$$NumberProduction1041$$" variable
		And I save the value of the field named "Date" as "$$DateProduction1041$$"
		And I save the window as "$$Production1041$$"
		And I save the value of the field named "Number" as "$$NumberProduction1041$$"
		And I click the button named "FormPostAndClose"
		Given I open hyperlink "e1cib/list/Document.Production"
		And "List" table contains lines
			| 'Number'                      |
			| '$$NumberProduction1041$$'    |
		And I close all client application windows
		

Scenario: _10342 check movements Production (Repacking)
	And I close all client application windows
	* Select Production (Repacking)
		Given I open hyperlink "e1cib/list/Document.Production"
		And I go to line in "List" table
			| 'Number'                      |
			| '$$NumberProduction1041$$'    |
		And I select current line in "List" table
	* R4010 Actual stocks
		And I click "Registrations report" button
		And I select "R4010 Actual stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$Production1041$$'                | ''              | ''                         | ''            | ''             | ''                                | ''                     |
			| 'Document registrations records'    | ''              | ''                         | ''            | ''             | ''                                | ''                     |
			| 'Register  "R4010 Actual stocks"'   | ''              | ''                         | ''            | ''             | ''                                | ''                     |
			| ''                                  | 'Record type'   | 'Period'                   | 'Resources'   | 'Dimensions'   | ''                                | ''                     |
			| ''                                  | ''              | ''                         | 'Quantity'    | 'Store'        | 'Item key'                        | 'Serial lot number'    |
			| ''                                  | 'Receipt'       | '$$DateProduction1041$$'   | '2'           | 'Store 02'     | 'Стремянка номер 5 ступенчатая'   | ''                     |
			| ''                                  | 'Expense'       | '$$DateProduction1041$$'   | '2'           | 'Store 03'     | 'Стремянка номер 8'               | ''                     |
	* R4011 Free stocks
		And I select "R4011 Free stocks" exact value from "Register" drop-down list
		And I click "Generate report" button
		Then "ResultTable" spreadsheet document is equal
			| '$$Production1041$$'               | ''              | ''                         | ''            | ''             | ''                                 |
			| 'Document registrations records'   | ''              | ''                         | ''            | ''             | ''                                 |
			| 'Register  "R4011 Free stocks"'    | ''              | ''                         | ''            | ''             | ''                                 |
			| ''                                 | 'Record type'   | 'Period'                   | 'Resources'   | 'Dimensions'   | ''                                 |
			| ''                                 | ''              | ''                         | 'Quantity'    | 'Store'        | 'Item key'                         |
			| ''                                 | 'Receipt'       | '$$DateProduction1041$$'   | '2'           | 'Store 02'     | 'Стремянка номер 5 ступенчатая'    |
			| ''                                 | 'Expense'       | '$$DateProduction1041$$'   | '2'           | 'Store 03'     | 'Стремянка номер 8'                |
	* R4050 Stock inventory
		And I select "R4050 Stock inventory" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| '$$Production1041$$'                  | ''              | ''                         | ''            | ''               | ''           | ''                                 |
			| 'Document registrations records'      | ''              | ''                         | ''            | ''               | ''           | ''                                 |
			| 'Register  "R4050 Stock inventory"'   | ''              | ''                         | ''            | ''               | ''           | ''                                 |
			| ''                                    | 'Record type'   | 'Period'                   | 'Resources'   | 'Dimensions'     | ''           | ''                                 |
			| ''                                    | ''              | ''                         | 'Quantity'    | 'Company'        | 'Store'      | 'Item key'                         |
			| ''                                    | 'Receipt'       | '$$DateProduction1041$$'   | '2'           | 'Main Company'   | 'Store 02'   | 'Стремянка номер 5 ступенчатая'    |
			| ''                                    | 'Expense'       | '$$DateProduction1041$$'   | '2'           | 'Main Company'   | 'Store 03'   | 'Стремянка номер 8'                |
	* T6010 Batches info
		And I select "T6010 Batches info" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| '$$Production1041$$'               | ''                         | ''               | ''                      |
			| 'Document registrations records'   | ''                         | ''               | ''                      |
			| 'Register  "T6010 Batches info"'   | ''                         | ''               | ''                      |
			| ''                                 | 'Period'                   | 'Dimensions'     | ''                      |
			| ''                                 | ''                         | 'Company'        | 'Document'              |
			| ''                                 | '$$DateProduction1041$$'   | 'Main Company'   | '$$Production1041$$'    |
	* T6020 Batch keys info
		And I select "T6020 Batch keys info" exact value from "Register" drop-down list
		And I click "Generate report" button	
		Then "ResultTable" spreadsheet document is equal
			| '$$Production1041$$'                | ''                       | ''          | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             | ''             | ''       | ''         | ''                              | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | ''                          | ''                          |
			| 'Document registrations records'    | ''                       | ''          | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             | ''             | ''       | ''         | ''                              | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | ''                          | ''                          |
			| 'Register  "T6020 Batch keys info"' | ''                       | ''          | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             | ''             | ''       | ''         | ''                              | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | ''                          | ''                          |
			| ''                                  | 'Period'                 | 'Resources' | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             | 'Dimensions'   | ''       | ''         | ''                              | ''          | ''                       | ''         | ''               | ''              | ''                                     | ''                   | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | ''                          | ''                          |
			| ''                                  | ''                       | 'Quantity'  | 'Invoice amount' | 'Invoice tax amount' | 'Indirect cost amount' | 'Indirect cost tax amount' | 'Extra cost amount by ratio' | 'Extra cost tax amount by ratio' | 'Extra direct cost amount' | 'Extra direct cost tax amount' | 'Allocated cost amount' | 'Allocated cost tax amount' | 'Allocated revenue amount' | 'Allocated revenue tax amount' | 'Company'      | 'Branch' | 'Store'    | 'Item key'                      | 'Direction' | 'Currency movement type' | 'Currency' | 'Batch document' | 'Sales invoice' | 'Row ID'                               | 'Profit loss center' | 'Expense type' | 'Work' | 'Work sheet' | 'DELETE batch consignor' | 'Serial lot number' | 'Source of origin' | 'Production document' | 'Purchase invoice document' |'Fixed asset'                |
			| ''                                  | '$$DateProduction1041$$' | '2'         | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             | 'Main Company' | ''       | 'Store 02' | 'Стремянка номер 5 ступенчатая' | 'Receipt'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | ''                          | ''                          |
			| ''                                  | '$$DateProduction1041$$' | '2'         | ''               | ''                   | ''                     | ''                         | ''                           | ''                               | ''                         | ''                             | ''                      | ''                          | ''                         | ''                             | 'Main Company' | ''       | 'Store 03' | 'Стремянка номер 8'             | 'Expense'   | ''                       | ''         | ''               | ''              | '                                    ' | ''                   | ''             | ''     | ''           | ''                       | ''                  | ''                 | ''                    | ''                          | ''                          |
	* R7030 Production planning
		And I select "R7030 Production planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R7030 Production planning"'    |
	* R7040 Manual materials corretion in production
		And I select "R7040 Manual materials corretion in production" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R7040 Manual materials corretion in production"'    |
	* R7020 Material planning	
		And I select "R7020 Material planning" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R7020 Material planning"'    |
	* R7010 Detailing supplies
		And I select "R7010 Detailing supplies" exact value from "Register" drop-down list
		And I click "Generate report" button
		And "ResultTable" spreadsheet document does not contain values
			| 'Register  "R7010 Detailing supplies"'    |
		And I close all client application windows
		
					
Scenario: _1043 verification of zero quantities by materials
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.Production"
	And I click the button named "FormCreate"
	* Filling in header info
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description'              |
			| 'Склад производства 05'    |
		And I select current line in "List" table		
	* Filling in production tab
		And I click Choice button of the field named "Item"
		And I go to line in "List" table
			| 'Description'          |
			| 'Стремянка номер 8'    |
		And I select current line in "List" table
		Then the form attribute named "ItemKey" became equal to "Стремянка номер 8"
	* Select Bill of materials and Store production
		And I click Select button of "Bill of materials" field
		And I go to line in "List" table
			| 'Description'                    |
			| 'Стремянка номер 8 (премиум)'    |
		And I select current line in "List" table
		And I input "2,000" text in the field named "Quantity"
		Then the form attribute named "BusinessUnit" became equal to "Склад производства 05"	
		And I click Select button of "Store production" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Store 01'       |
		And I select current line in "List" table	
	* Change material quantity
		And for each line of "Materials" table I do
			And I input "0,000" text in the field named "MaterialsQuantity" of "Materials" table
			And I activate "Material type" field in "Materials" table
			And I select current line in "Materials" table
			And I select "Material" exact value from "Material type" drop-down list in "Materials" table
	* Try post
		And I click "Post and close" button
		Then there are lines in TestClient message log
			| 'Quantity must be more than 0'    |
		Then "Production (create) *" window is opened	
		And I close all client application windows
		
				
	
				
						

		
						

				
