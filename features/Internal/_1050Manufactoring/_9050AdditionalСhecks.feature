#language: en
@tree
@SettingsFilters


Feature: additional checks


Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I open new TestClient session or connect the existing one

Scenario: _9050 preparation
	When set True value to the constant
	When change interface localization code for CI (en)
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
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
	When update ItemKeys
	When Create information register CurrencyRates records
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	When Create catalog MFBillOfMaterials objects
	When Create catalog PlanningPeriods objects (MF)
	When Create catalog ObjectStatuses objects
	When Create catalog ObjectStatuses objects (MF)
	When Create document ProductionPlanning objects
	And Delay 5
	When Create document Production objects
	And Delay 5
	And I execute 1C:Enterprise script at server
		| "Documents.Production.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |	
		| "Documents.Production.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.Production.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.Production.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);" |
	When Create document ProductionPlanningCorrection objects
	And Delay 5
	When Create document InternalSupplyRequest objects (second period) (MF)
	And I execute 1C:Enterprise script at server
		| "Documents.InternalSupplyRequest.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |	


Scenario: _9051 checking duplicate materials in one BillOfMaterials
	Given I open hyperlink "e1cib/list/Catalog.BillOfMaterials"
	And I click the button named "FormCreate"
	And I click Select button of "Business unit" field
	And I go to line in "List" table
		| 'Description'         |
		| 'Production store 05' |
	And I select current line in "List" table
	And I input "Test" text in "ENG" field
	And I click Choice button of the field named "Item"
	And I go to line in "List" table
		| 'Description'            |
		| 'Стремянка CLASS PLUS 8' |
	And I activate "Description" field in "List" table
	And I select current line in "List" table
	And in the table "Content" I click the button named "ContentAdd"
	And I click choice button of the attribute named "ContentItem" in "Content" table
	And I go to line in "List" table
		| 'Description'       |
		| 'Катанка Ст3сп 6,5' |
	And I activate "Description" field in "List" table
	And I select current line in "List" table
	And I finish line editing in "Content" table
	And in the table "Content" I click the button named "ContentAdd"
	And I click choice button of the attribute named "ContentItem" in "Content" table
	And I go to line in "List" table
		| 'Description'       |
		| 'Катанка Ст3сп 6,5' |
	And I activate "Description" field in "List" table
	And I select current line in "List" table
	And I activate field named "ContentQuantity" in "Content" table
	And I input "2,000" text in the field named "ContentQuantity" of "Content" table
	And I finish line editing in "Content" table
	And I click "Save" button
	Then I wait that in user messages the "Repetitive materials [Катанка Ст3сп 6,5, Катанка Ст3сп 6,5]" substring will appear in 30 seconds
	Then "Bill of materials (create) *" window is opened
	And I close all client application windows
	
		
Scenario: _9053 checking interdependent semi products in the BillOfMaterials
	* Create first BillOfMaterials
		Given I open hyperlink "e1cib/list/Catalog.BillOfMaterials"
		And I click the button named "FormCreate"
		And I input "Упаковка 01" text in "ENG" field
		And I click Choice button of the field named "Item"
		And I go to line in "List" table
			| 'Description'                             |
			| 'Упаковка 01' |
		And I select current line in "List" table
		And I click Choice button of the field named "ItemKey"
		And I close "Item keys" window
		Then the form attribute named "Unit" became equal to "pcs"
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
		And in the table "Content" I click the button named "ContentAdd"
		And I click choice button of the attribute named "ContentItem" in "Content" table
		And I go to line in "List" table
			| 'Description' |
			| 'Упаковка 02'     |
		And I select current line in "List" table
		And I activate field named "ContentQuantity" in "Content" table
		And I select current line in "Content" table
		And I input "2" text in the field named "ContentQuantity" of "Content" table
		And I finish line editing in "Content" table
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description' |
			| 'Manufactory 06'      |
		And I select current line in "List" table		
		And I click "Save and close" button
	* Create second BillOfMaterials with interdependent semi product
		And I click the button named "FormCreate"
		And I input "Упаковка 02" text in "ENG" field
		And I click Choice button of the field named "Item"
		And I go to line in "List" table
			| 'Description'                             |
			| 'Упаковка 02' |
		And I select current line in "List" table
		And I click Choice button of the field named "ItemKey"
		And I close "Item keys" window
		Then the form attribute named "Unit" became equal to "pcs"
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
		And in the table "Content" I click the button named "ContentAdd"
		And I click choice button of the attribute named "ContentItem" in "Content" table
		And I go to line in "List" table
			| 'Description' |
			| 'Упаковка 01'     |
		And I select current line in "List" table
		And I activate field named "ContentQuantity" in "Content" table
		And I select current line in "Content" table
		And I input "2" text in the field named "ContentQuantity" of "Content" table
		And I finish line editing in "Content" table
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description' |
			| 'Manufactory 06'      |
		And I select current line in "List" table		
		And I click "Save and close" button
		And "List" table contains lines
		| 'Description' |
		| 'Упаковка 01' |
		| 'Упаковка 02' |
		And I close all client application windows

Scenario: _9055 checking that planning periods do not overlap for one Business Unit
	Given I open hyperlink "e1cib/list/Catalog.PlanningPeriods"
	And "List" table contains lines
		| 'Description'   |
		| 'Next day'      |
	And I click the button named "FormCreate"
	And I input "Current month (Manufactory 06)" text in "Description" field
	And I input end of the current month date in "End date" field
	And I input begin of the current month date in "Begin date" field
	And I change the radio button named "Type" value to "Manufacturing"
	And in the table "BusinessUnits" I click the button named "BusinessUnitsAdd"
	And I click choice button of "Business unit" attribute in "BusinessUnits" table
	And I go to line in "List" table
		| 'Description'           |
		| 'Manufactory 06' |
	And I select current line in "List" table
	And I click "Save and close" button	
	When TestClient log message contains "* intersect Period [Current day]" string by template
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.PlanningPeriods"
	And I click the button named "FormCreate"
	And I input "Current day (Manufactory 07)" text in "Description" field
	And I input current date in "Begin date" field
	And I input current date in "End date" field
	And I change the radio button named "Type" value to "Manufacturing"
	And in the table "BusinessUnits" I click the button named "BusinessUnitsAdd"
	And I click choice button of "Business unit" attribute in "BusinessUnits" table
	And I go to line in "List" table
		| 'Description'           |
		| 'Manufactory 07' |
	And I select current line in "List" table
	And I click "Save and close" button	
	When TestClient log message contains "* intersect Period [Current month]" string by template
	And I close all client application windows

Scenario: _9057 checking that for one Company, Bussines unit and Planning period can be only one Production Planning
	Given I open hyperlink "e1cib/list/Document.ProductionPlanning"
	And "List" table contains lines
		| 'Number' |
		| '3'      |
	And I go to line in "List" table
		| 'Number'           |
		| '3' |
	And in the table "List" I click the button named "ListContextMenuCopy"
	And I click "No" button
	And I click "Post and close" button
	Given Recent TestClient message contains "Planning by [Main Company] [Production store 05] [Third month] alredy exists" string by template
	And I close all client application windows

Scenario: _9059 checking that Production planning correction should be a later date than Production planning
		And I close all client application windows
	* Create Production planning correction based on ProductionPlanning
		Given I open hyperlink "e1cib/list/Document.ProductionPlanning"
		And "List" table contains lines
			| 'Number' | 'Company'      | 'Business unit'       | 'Planning period' |
			| '2'      | 'Main Company' | 'Production store 05' | 'Second month'    |
		And I go to line in "List" table
			| 'Number'           |
			| '2' |
		And I click "Production planning correction" button
		Then "Production planning correction (create)" window is opened
		And I move to "Other" tab
		And I input "01.04.2022 00:00:00" text in the field named "Date"		
		And I move to the next attribute
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I click Choice button of the field named "PlanningPeriod"
		And I go to line in "List" table
			| 'Description'  |
			| 'Second month' |
		And I select current line in "List" table		
		And I click "Post and close" button
		Given Recent TestClient message contains "Document date [*] less than Planning date [*]" string by template
		And I close all client application windows
	* Create Production planning correction independently
		Given I open hyperlink "e1cib/list/Document.ProductionPlanningCorrection"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'     |
		And I select current line in "List" table
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Production store 05' |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		And I move to "Productions" tab
		And I move to "Other" tab
		And I click Select button of "Planning period" field
		And I go to line in "List" table
			| 'Description'  |
			| 'Second month' |
		And I select current line in "List" table
		And I move to "Productions" tab
		And in the table "Productions" I click the button named "ProductionsAdd"
		And I click choice button of "Item" attribute in "Productions" table
		And I go to line in "List" table
			| 'Description'                        |
			| 'Стремянка CLASS PLUS 5 ступенчатая' |
		And I select current line in "List" table
		And I activate "Q" field in "Productions" table
		And I select current line in "Productions" table
		And I input "260,000" text in "Q" field of "Productions" table
		And I click choice button of "Bill of materials" attribute in "Productions" table
		And I go to line in "List" table
			| 'Item'                               | 'Item key'                           |
			| 'Стремянка CLASS PLUS 5 ступенчатая' | 'Стремянка CLASS PLUS 5 ступенчатая' |
		And I select current line in "List" table
		And I finish line editing in "Productions" table
		And I input "01.04.2022 00:00:00" text in the field named "Date"
		And I move to the next attribute
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I click Choice button of the field named "PlanningPeriod"
		And I go to line in "List" table
			| 'Description'  |
			| 'Second month' |
		And I select current line in "List" table		
		And I click "Post and close" button
		Given Recent TestClient message contains "Document date [*] less than Planning date [*]" string by template
		And I close all client application windows
	
	
Scenario: _9060 checking that the second Production planning correction must be later than the first
	* Change date and check message
		Given I open hyperlink "e1cib/list/Document.ProductionPlanningCorrection"
		And "List" table contains lines
			| 'Number'                                   |
			| '2' |
			| '3' |
		And I go to line in "List" table
			| 'Number'                        |
			| '3' |
		And I select current line in "List" table
		And I move to "Other" tab
		And I save "CurrentDate()+480" in "$$$$Date1$$$$" variable
		And I input "$$$$Date1$$$$" variable value in "Date" field
		And I move to the next attribute
		And I click "Yes" button
		And I click the hyperlink named "DecorationGroupTitleCollapsedPicture"
		And I click Select button of "Planning period" field
		And I go to line in "List" table
			| 'Description' |
			| 'Third month' |
		And I select current line in "List" table
		And I click "Post and close" button
		And I close all client application windows
	* Create one more ProductionPlanningCorrection and check message
		Given I open hyperlink "e1cib/list/Document.ProductionPlanningCorrection"
		And I click the button named "FormCreate"
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description' |
			| 'Main Company'     |
		And I select current line in "List" table
		And I click Select button of "Business unit" field
		And I go to line in "List" table
			| 'Description'           |
			| 'Production store 05' |
		And I select current line in "List" table
		And I select "Approved" exact value from "Status" drop-down list
		And I move to "Productions" tab
		And I move to "Other" tab
		And I click Select button of "Planning period" field
		And I go to line in "List" table
			| 'Description' |
			| 'Third month' |
		And I select current line in "List" table
		And I click Select button of "Production planning" field
		And I go to line in "List" table
			| 'Number' | 'Planning period' |
			| '3'      | 'Third month'    |
		And I activate "Date" field in "List" table
		And I select current line in "List" table
		Then the form attribute named "PlanningPeriod" became equal to "Third month"
		And I move to "Productions" tab
		And in the table "Productions" I click the button named "ProductionsAdd"
		And I click choice button of "Item" attribute in "Productions" table
		And I go to line in "List" table
			| 'Description'            |
			| 'Стремянка CLASS PLUS 8' |
		And I select current line in "List" table
		And I click choice button of "Bill of materials" attribute in "Productions" table
		And I go to line in "List" table
			| 'Description'                       |
			| 'Стремянка CLASS PLUS 8 (премиум)' |
		And I select current line in "List" table		
		And I activate "Q" field in "Productions" table
		And I input "132,000" text in "Q" field of "Productions" table
		And I finish line editing in "Productions" table
		And I save "CurrentDate() + 260" in "$$$$Date2$$$$" variable
		And I input "$$$$Date2$$$$" variable value in "Date" field
		And I move to the next attribute
		And I click "Yes" button
		And I click Select button of "Planning period" field
		And I go to line in "List" table
			| 'Description' |
			| 'Third month'     |
		And I click "Select" button
		And I delete "$$NumberProductionPlanningCorrection04$$" variable
		And I delete "$$ProductionPlanningCorrection03$$" variable
		And I save the value of "Number" field as "$$NumberProductionPlanningCorrection04$$"
		And I save the window as "$$ProductionPlanningCorrection04$$"
		And I click "Post and close" button
		Given Recent TestClient message contains "Document date [*] less than last Planning correction date [*]" string by template
		And I close all client application windows
		
Scenario: _9062 checking that Production (date) must be later than the Production planning
	* Change date and check message
		Given I open hyperlink "e1cib/list/Document.Production"
		And "List" table contains lines
			| 'Number'                                   |
			| '1' |
		And I go to line in "List" table
			| 'Number'                        |
			| '1' |
		And I select current line in "List" table
		And I move to "Other" tab
		And I input "29.04.2022 08:00:00" text in the field named "Date"
		And I move to the next attribute		
		And I click "Post and close" button
		Given Recent TestClient message contains "Document date [*] less than Planning date [*]" string by template
		And I close all client application windows
	* Create one more Production and check message
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
				| 'Production store 05'     |
			And I select current line in "List" table
			And I click Select button of "Store production" field
			And I go to line in "List" table
				| 'Description' |
				| 'Store 05'     |
			And I select current line in "List" table
			And I click Select button of "Production planning" field
			And I go to line in "List" table
				| 'Number'                               |
				| '1' |
			And I select current line in "List" table
			Then the form attribute named "PlanningPeriod" became equal to "First month"
		* Filling in production tab
			And I move to "Production" tab
			And I click Choice button of the field named "Item"
			And I go to line in "List" table
				| 'Description'                        |
				| 'Копыта на стремянки Класс 20х20, черный' |
			And I select current line in "List" table
			Then the form attribute named "ItemKey" became equal to "Копыта на стремянки Класс 20х20, черный"
			And I click Select button of "Bill of materials" field
			And I go to line in "List" table
				| 'Description'                        | 'Item key'    |
				| '01 Копыта на стремянки Класс 20х20' | 'Копыта на стремянки Класс 20х20, черный' |
			And I select current line in "List" table		
			Then the form attribute named "BillOfMaterials" became equal to "01 Копыта на стремянки Класс 20х20"
			Then the form attribute named "Unit" became equal to "pcs"
			And I input "20,000" text in the field named "Quantity"
			And I move to "Materials" tab	
			And "Materials" table contains lines
				| 'Item'    | 'Item key' | 'Unit' | 'Q'      |
				| 'ПВД 158' | 'ПВД 158'  | 'кг'   | '19,600' |
			Then the number of "Materials" table lines is "меньше или равно" "1"
			And I select "Material" exact value from "Material type" drop-down list in "Materials" table		
			And I input "01.04.2022 00:00:00" text in the field named "Date"
			And I click "Post and close" button
			Given Recent TestClient message contains "Document date [*] less than Planning date [*]" string by template
			Then "Production (create) *" window is opened
			And I close all client application windows

Scenario: _9063 check the blocking of BillOfMaterials if a Production Planning document is created for it
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ProductionPlanning"
	And "List" table contains lines
		| 'Number'                                   |
		| '1' |	
	* Try to change BillOfMaterials
		Given I open hyperlink "e1cib/list/Catalog.BillOfMaterials"
		And I go to line in "List" table
			| 'Description'                        |
			| 'Стремянка CLASS PLUS 6 ступенчатая' |
		And I select current line in "List" table
		And the field named "ProductionPlanningExists" is filled
		When I Check the steps for Exception
			|"And in the table 'Content' I click the button named 'ContentAdd'"|				
	And I close all client application windows

Scenario: _9064	try delete Bill of materials with Production planning document
		And I close all client application windows
	* Select BillOfMaterials
		Given I open hyperlink "e1cib/list/Catalog.BillOfMaterials"
		And I go to line in "List" table
			| 'Description'                        |
			| 'Стремянка CLASS PLUS 6 ступенчатая' |
		And I select current line in "List" table
		And the field named "ProductionPlanningExists" is filled
	* Try mark for deletion
		When I Check the steps for Exception
			|"And I click "Mark for deletion / Unmark for deletion" button"|
		And I close all client application windows


Scenario: _9065 non active and default Bill of materials
		And I close all client application windows
	* Default Bill of materials
		Given I open hyperlink "e1cib/list/Catalog.BillOfMaterials"
		And I go to line in "List" table
			| 'Description'                        |
			| 'Стремянка CLASS PLUS 8 (основная)' |
		And I select current line in "List" table
		And I click "Set as default" button
		And I close current window	
	* Select BillOfMaterials with Production planning document
		Given I open hyperlink "e1cib/list/Catalog.BillOfMaterials"
		And I go to line in "List" table
			| 'Description'                        |
			| 'Стремянка CLASS PLUS 6 ступенчатая' |
		And I select current line in "List" table
		And I click the button named "ChangeActive"
		And I close current window
	* Select BillOfMaterials without Production planning document
		Given I open hyperlink "e1cib/list/Catalog.BillOfMaterials"
		And I go to line in "List" table
			| 'Description'                        |
			| 'Стремянка CLASS PLUS 8 (премиум)' |
		And I select current line in "List" table
		And I click the button named "ChangeActive"
		And I click "Save and close" button
	* Check
		Given I open hyperlink "e1cib/list/Document.ProductionPlanning"
		And I click "Create" button
		And in the table "Productions" I click "Add" button
		And I activate "Item" field in "Productions" table
		And I select current line in "Productions" table
		And I click choice button of "Item" attribute in "Productions" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                        |
			| 'Стремянка CLASS PLUS 6 ступенчатая' |
		And I select current line in "List" table
		And "Productions" table became equal
			| 'Item'                               | 'Item key'                           | 'Unit' | 'Q'     | 'Bill of materials' |
			| 'Стремянка CLASS PLUS 6 ступенчатая' | 'Стремянка CLASS PLUS 6 ступенчатая' | 'pcs'  | '1,000' | ''                  |
		And in the table "Productions" I click "Add" button
		And I activate "Item" field in "Productions" table
		And I select current line in "Productions" table
		And I click choice button of "Item" attribute in "Productions" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                        |
			| 'Стремянка CLASS PLUS 8' |
		And I select current line in "List" table
		And "Productions" table became equal
			| 'Item'                               | 'Item key'                           | 'Unit' | 'Q'     | 'Bill of materials'                 |
			| 'Стремянка CLASS PLUS 6 ступенчатая' | 'Стремянка CLASS PLUS 6 ступенчатая' | 'pcs'  | '1,000' | ''                                  |
			| 'Стремянка CLASS PLUS 8'             | 'Стремянка CLASS PLUS 8'             | 'pcs'  | '1,000' | 'Стремянка CLASS PLUS 8 (основная)' |
	* Try select non active Bill of materials
		And I go to line in "Productions" table
			| 'Item'                   |
			| 'Стремянка CLASS PLUS 8' |
		And I click choice button of "Bill of materials" attribute in "Productions" table
		And "List" table became equal
			| 'Description'                       | 'Item'                   | 'Item key'               |
			| 'Стремянка CLASS PLUS 8 (основная)' | 'Стремянка CLASS PLUS 8' | 'Стремянка CLASS PLUS 8' |
		And I close all client application windows
	* Active Bill of materials
		Given I open hyperlink "e1cib/list/Catalog.BillOfMaterials"
		And I go to line in "List" table
			| 'Description'                        |
			| 'Стремянка CLASS PLUS 6 ступенчатая' |
		And I select current line in "List" table
		And I click the button named "ChangeActive"
		And I close current window
		Given I open hyperlink "e1cib/list/Catalog.BillOfMaterials"
		And I go to line in "List" table
			| 'Description'                        |
			| 'Стремянка CLASS PLUS 8 (премиум)' |
		And I select current line in "List" table
		And I click the button named "ChangeActive"
		And I click "Save and close" button
	* Check
		Given I open hyperlink "e1cib/list/Document.ProductionPlanning"
		And I click "Create" button
		And in the table "Productions" I click "Add" button
		And I activate "Item" field in "Productions" table
		And I select current line in "Productions" table
		And I click choice button of "Item" attribute in "Productions" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                        |
			| 'Стремянка CLASS PLUS 6 ступенчатая' |
		And I select current line in "List" table
		And "Productions" table became equal
			| 'Item'                               | 'Item key'                           | 'Unit' | 'Q'     | 'Bill of materials'                  |
			| 'Стремянка CLASS PLUS 6 ступенчатая' | 'Стремянка CLASS PLUS 6 ступенчатая' | 'pcs'  | '1,000' | 'Стремянка CLASS PLUS 6 ступенчатая' |
		And in the table "Productions" I click "Add" button
		And I activate "Item" field in "Productions" table
		And I select current line in "Productions" table
		And I click choice button of "Item" attribute in "Productions" table
		Then "Items" window is opened
		And I go to line in "List" table
			| 'Description'                        |
			| 'Стремянка CLASS PLUS 8' |
		And I select current line in "List" table
		And "Productions" table became equal
			| 'Item'                               | 'Item key'                           | 'Unit' | 'Q'     | 'Bill of materials'                  |
			| 'Стремянка CLASS PLUS 6 ступенчатая' | 'Стремянка CLASS PLUS 6 ступенчатая' | 'pcs'  | '1,000' | 'Стремянка CLASS PLUS 6 ступенчатая' |
			| 'Стремянка CLASS PLUS 8'             | 'Стремянка CLASS PLUS 8'             | 'pcs'  | '1,000' | 'Стремянка CLASS PLUS 8 (основная)'  |
		And I go to line in "Productions" table
			| 'Item'                   |
			| 'Стремянка CLASS PLUS 8' |
		And I click choice button of "Bill of materials" attribute in "Productions" table
		And "List" table became equal
			| 'Description'                       | 'Item'                   | 'Item key'               |
			| 'Стремянка CLASS PLUS 8 (основная)' | 'Стремянка CLASS PLUS 8' | 'Стремянка CLASS PLUS 8' |
			| 'Стремянка CLASS PLUS 8 (премиум)'  | 'Стремянка CLASS PLUS 8' | 'Стремянка CLASS PLUS 8' |
		And I close all client application windows
				


Scenario: _9067 check the blocking of Production Planning document if an Production Planning Correction is created for it
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ProductionPlanning"
	And I go to line in "List" table
		| 'Number'                                   |
		| '3' |
	And I select current line in "List" table
	And the editing text of form attribute named "DependentDocument" became equal to "Production planning correction*" by template
	* Try to change ProductionPlanning
		When I Check the steps for Exception
			|"And in the table "Productions" I click the button named "ProductionsAdd""|
	And I close all client application windows	


// Scenario: _9069 check the blocking of Production Planning document if an Production is created for it
// 	* Unpost ISR
// 		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
// 		And I go to line in "List" table
// 			| 'Number'                                   |
// 			| '2' |
// 		And in the table "List" I click the button named "ListContextMenuUndoPosting"
// 		And I go to line in "List" table
// 			| 'Number'                                   |
// 			| '2' |
// 		And in the table "List" I click the button named "ListContextMenuUndoPosting"
// 	* Check blocking of Production Planning
// 		Given I open hyperlink "e1cib/list/Document.ProductionPlanning"
// 		And I go to line in "List" table
// 			| 'Number'                                   |
// 			| '2' |
// 		And I select current line in "List" table
// 		Then the form attribute named "DependentDocument" became equal to "$$Production02$$"
// 		* Try to change ProductionPlanning
// 			When I Check the steps for Exception
// 				|"And in the table "Productions" I click the button named "ProductionsAdd""|
// 			And I close current window
// 	* Check unbloking of Production Planning
// 		And I go to line in "List" table
// 			| 'Number'                                   |
// 			| '$$NumberProductionPlanning01113011$$' |
// 		And I select current line in "List" table
// 		Then the form attribute named "DependentDocument" became equal to ""
// 		And in the table "Productions" I click the button named "ProductionsAdd"
// 		And I close all client application windows
// 	* Post ISR back
// 		Given I open hyperlink "e1cib/list/Document.InternalSupplyRequest"
// 		And I go to line in "List" table
// 			| 'Number'                                   |
// 			| '$$NumberInternalSupplyRequest01103110$$' |
// 		And in the table "List" I click the button named "ListContextMenuPost"
// 		And I go to line in "List" table
// 			| 'Number'                                   |
// 			| '$$NumberInternalSupplyRequest01103111$$' |
// 		And in the table "List" I click the button named "ListContextMenuPost"
// 	And I close all client application windows

Scenario: _9071 check the blocking Production Planning Correction if it is not the last in the chain
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Document.ProductionPlanningCorrection"
	And I go to line in "List" table
		| 'Number'                                   |
		| '3' |
	And I select current line in "List" table
	And I delete "$$NextProductionPlanningCorrection03$$" variable
	And I save the window as "$$NextProductionPlanningCorrection03$$"
	And I close current window
	And I go to line in "List" table
		| 'Number'                                   |
		| '2' |
	And I select current line in "List" table
	Then the form attribute named "ProductionPlanningCorrectionExists" became equal to "$$NextProductionPlanningCorrection03$$"
	* Try to change ProductionPlanning
		When I Check the steps for Exception
			|"And in the table "Productions" I click the button named "ProductionsAdd""|
	And I close all client application windows

	

Scenario: _9073 checking the blocking of Start date and End Date in the Planning priods catalog if there is already a Production planning document
	Given I open hyperlink "e1cib/list/Catalog.PlanningPeriods"
	And I go to line in "List" table
		| 'Description'                                   |
		| 'First month' |
	And I select current line in "List" table
	And the form attribute named "ProductionPlanningExists" became equal to "Production planning*" template
	* Try to change Start and End Date
		When I Check the steps for Exception
			|"And I input "$$$$DateStartThirdMonth$$$$" variable value in "Start date" field"|
		When I Check the steps for Exception
			|"And I input "$$$$DateEndThirdMonth$$$$" variable value in "End date" field"|
	And I close all client application windows
	
	





		

	
		




	