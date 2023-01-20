#language: en
@tree
@LandedCostProduction

Feature: landed cost production

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I open new TestClient session or connect the existing one



Scenario: _2000 preparation (landed cost)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	When Create catalog AddAttributeAndPropertySets objects
	When Create catalog AddAttributeAndPropertyValues objects
	When Create chart of characteristic types AddAttributeAndProperty objects
	When Create catalog Partners objects (Ferron BP)
	When Create catalog Companies objects (partners company)
	When Create information register PartnerSegments records
	When Create catalog Agreements objects
	When Create catalog ExpenseAndRevenueTypes objects
	When Create catalog TaxRates objects
	When Create catalog Taxes objects	
	When Create information register TaxSettings records
	When Create catalog IntegrationSettings objects
	When Create catalog Companies objects (Main company)
	When Create catalog ItemTypes objects
	When Create catalog Stores objects
	When Create chart of characteristic types CurrencyMovementType objects
	When Create catalog Currencies objects
	When Create catalog BusinessUnits objects
	When Create catalog BusinessUnits objects (MF)
	When Create catalog Countries objects
	When Create catalog Items objects
	When Create catalog Units objects
	When Create catalog Units objects (MF)
	When Create catalog ItemKeys objects
	When Create catalog Items objects (MF)
	When Create catalog ItemKeys objects (MF)
	When Create catalog ItemTypes objects (MF)
	When Create Items and item keys (semiproducts) (MF)
	When update ItemKeys
	When Create information register CurrencyRates records
	When Create catalog PriceTypes objects
	When Create catalog Companies objects (own Second company)	
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	* Landed cost currency movement type for company
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I select "Company" exact value from the drop-down list named "Type"
		And I move to "Landed cost" tab
		And I click Select button of "Currency movement type" field
		And I go to line in "List" table
			| 'Currency' | 'Deferred calculation' | 'Description'    | 'Reference'      | 'Source'       | 'Type'  |
			| 'TRY'      | 'No'                   | 'Local currency' | 'Local currency' | 'Forex Seling' | 'Legal' |
		And I select current line in "List" table
		Then the form attribute named "LandedCostCurrencyMovementType" became equal to "Local currency"
		And I move to "Tax types" tab
		And I set "Include to landed cost" checkbox in "CompanyTaxes" table
		And I finish line editing in "CompanyTaxes" table	
		And I click "Save and close" button
		And I wait "Main Company (Company) *" window closing in 20 seconds
		Then "Companies" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Second Company' |
		And I select current line in "List" table
		And I select "Company" exact value from the drop-down list named "Type"
		And I move to "Landed cost" tab
		And I click Select button of "Currency movement type" field
		And I go to line in "List" table
			| 'Currency' | 'Deferred calculation' | 'Description'    | 'Reference'      | 'Source'       | 'Type'  |
			| 'TRY'      | 'No'                   | 'Local currency' | 'Local currency' | 'Forex Seling' | 'Legal' |
		And I select current line in "List" table
		Then the form attribute named "LandedCostCurrencyMovementType" became equal to "Local currency"
		And I click "Save and close" button
	When Create document SalesInvoice objects (MF)
	When Create catalog ReportOptions objects
	When Create catalog MFBillOfMaterials objects
	When Create catalog PlanningPeriods objects (MF)
	When Create catalog BillOfMaterials objects (semiproducts)
	When Create document ProductionPlanning objects
	When Create document ProductionPlanning objects (first period)
	When Create document PurchaseInvoice objects (production landed cost) (MF)
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(11).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
		| "Documents.PurchaseInvoice.FindByNumber(13).GetObject().Write(DocumentWriteMode.Posting);" |
	When Create document Production objects
	When Create document Production objects (semiproducts)
	And I execute 1C:Enterprise script at server
		| "Documents.Production.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
		| "Documents.Production.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
		| "Documents.Production.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
		| "Documents.Production.FindByNumber(12).GetObject().Write(DocumentWriteMode.Posting);" |
		| "Documents.SalesInvoice.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);" |
	And I execute 1C:Enterprise script at server
		| "Documents.SalesInvoice.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);" |
	And I close all client application windows


Scenario: _2008 create production cost allocation (not direct cost)
	And I close all client application windows
	* Create Production cost allocation
		Given I open hyperlink "e1cib/list/Document.ProductionCostsAllocation"
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I input current date in "Begin date" field
		And I input current date in "End date" field
	* Fill duration
		And in the table "ProductionDurationsList" I click "Fill durations" button
	* Check filling
		And "ProductionDurationsList" table became equal
			| '#' | 'Business unit'       | 'Amount' | 'Item'                                    | 'Duration' | 'Item key'                                |
			| '1' | 'Production store 05' | ''       | 'Копыта на стремянки Класс 20х20, черный' | '40,00'    | 'Копыта на стремянки Класс 20х20, черный' |
			| '2' | 'Production store 05' | ''       | 'Стремянка номер 6 ступенчатая'           | '250,00'   | 'Стремянка номер 6 ступенчатая'           |
			| '3' | 'Production store 05' | ''       | 'Стремянка номер 8'                       | '18,00'    | 'Стремянка номер 8'                       |
	* Add cost
		And in the table "ProductionCostsList" I click the button named "ProductionCostsListAdd"
		And I activate "Profit loss center" field in "ProductionCostsList" table
		And I select current line in "ProductionCostsList" table
		And I click choice button of "Profit loss center" attribute in "ProductionCostsList" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Manufactory 06' |
		And I select current line in "List" table
		And I activate "Expense type" field in "ProductionCostsList" table
		And I click choice button of "Expense type" attribute in "ProductionCostsList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Expense'     |
		And I select current line in "List" table
		And I activate "Currency" field in "ProductionCostsList" table
		And I click choice button of "Currency" attribute in "ProductionCostsList" table
		And I go to line in "List" table
			| 'Description'  |
			| 'Turkish lira' |
		And I select current line in "List" table
		And I finish line editing in "ProductionCostsList" table
		And I activate field named "ProductionCostsListAmount" in "ProductionCostsList" table
		And I select current line in "ProductionCostsList" table
		And I input "1 000,00" text in the field named "ProductionCostsListAmount" of "ProductionCostsList" table
		And I finish line editing in "ProductionCostsList" table
		And in the table "ProductionCostsList" I click the button named "ProductionCostsListAdd"
		And I activate "Profit loss center" field in "ProductionCostsList" table
		And I click choice button of "Profit loss center" attribute in "ProductionCostsList" table
		Then "Business units" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Manufactory 07' |
		And I select current line in "List" table
		And I activate "Expense type" field in "ProductionCostsList" table
		And I click choice button of "Expense type" attribute in "ProductionCostsList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Delivery'    |
		And I select current line in "List" table
		And I click choice button of "Currency" attribute in "ProductionCostsList" table
		And I select current line in "List" table
		And I activate field named "ProductionCostsListAmount" in "ProductionCostsList" table
		And I input "2 000,00" text in the field named "ProductionCostsListAmount" of "ProductionCostsList" table
		And I finish line editing in "ProductionCostsList" table
		And I move to "Durations" tab
	* Allocate amount
		And in the table "ProductionDurationsList" I click "Allocate amounts" button
		And "ProductionDurationsList" table became equal
			| '#' | 'Business unit'       | 'Amount'   | 'Item'                                    | 'Duration' | 'Item key'                                |
			| '1' | 'Production store 05' | '389,60'   | 'Копыта на стремянки Класс 20х20, черный' | '40,00'    | 'Копыта на стремянки Класс 20х20, черный' |
			| '2' | 'Production store 05' | '2 435,08' | 'Стремянка номер 6 ступенчатая'           | '250,00'   | 'Стремянка номер 6 ступенчатая'           |
			| '3' | 'Production store 05' | '175,32'   | 'Стремянка номер 8'                       | '18,00'    | 'Стремянка номер 8'                       |
	* Post
		And I click the button named "FormPost"
		And I delete "$$NumberProductionCostsAllocation1$$" variable
		And I delete "$$ProductionCostsAllocation1$$" variable
		And I save the value of the field named "Number" as "$$NumberProductionCostsAllocation1$$"
		And I save the window as "$$ProductionCostsAllocation1$$"	
		And I click the button named "FormPostAndClose"
		And "List" table contains lines
			| 'Number'                               |
			| '$$NumberProductionCostsAllocation1$$' |
		And I close all client application windows									
				
									


Scenario: _2010 create Calculation movement costs (batch realocate)
	* Open cretion form
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I click the button named "FormCreate"
	* Fill and post
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I select "Landed cost (batch reallocate)" exact value from "Calculation mode" drop-down list
		And I input current date in "Begin date" field
		And I input current date in "End date" field
		And I click the button named "FormPost"
		And I delete "$$NumberCalculationMovementCosts1$$" variable
		And I delete "$$CalculationMovementCosts1$$" variable
		And I save the value of "Number" field as "$$NumberCalculationMovementCosts1$$"
		And I save the window as "$$CalculationMovementCosts1$$"
		And I click the button named "FormPostAndClose"
	* Check
		And "List" table contains lines
			| 'Number'                              |
			| '$$NumberCalculationMovementCosts1$$' |
		And I close all client application windows
		

Scenario: _2012 check batch calculation
	Given I open hyperlink "e1cib/app/Report.BatchBalance"
	And I click "Select option..." button
	And I move to "Custom" tab
	And I activate field named "OptionsListReportOption" in "OptionsList" table
	And I select current line in "OptionsList" table
	And I click "Generate" button
	Given "Result" spreadsheet document is equal to "LandedCost" by template
	And I close all client application windows
	
Scenario: _2013 check batch calculation (one semiproduct consists of another semiproduct, with cost ratio)
	And I close all client application windows
	* Preparation
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(14).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.Production.FindByNumber(15).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.Production.FindByNumber(14).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.Production.FindByNumber(13).GetObject().Write(DocumentWriteMode.Posting);" |
	* Repost Calculation movement costs
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to line in "List" table
			| 'Number'                              |
			| '$$NumberCalculationMovementCosts1$$' |
		And in the table "List" I click the button named "ListContextMenuPost"		
	* Check batches calculation
		Given I open hyperlink "e1cib/app/Report.BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I move to "Standard" tab
		And I select current line in "StandardOptions" table	
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| 'Item'    | 'Item key'    |
			| 'Product' | 'Product' |
		And I select current line in "List" table
		And I click "Generate" button
		Given "Result" spreadsheet document is equal to "LandedCost2" by template
	
				
		
				
