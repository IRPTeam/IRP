#language: en
@tree
@ProductionPlanningClosing

Feature: Reservation


Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I open new TestClient session or connect the existing one



Scenario: _7001 Production planning closing
	When set True value to the constant
	When Create catalog Partners objects (Ferron BP)
	When Create catalog Companies objects (partners company)
	When Create information register PartnerSegments records
	When Create catalog Agreements objects
	When Create catalog TaxRates objects
	When Create catalog Taxes objects	
	When Create information register TaxSettings records
	When Create catalog IntegrationSettings objects
	When Create catalog Companies objects (Main company)
	When Create information register CurrencyRates records
	When Create information register Taxes records (VAT)
	When Create catalog AddAttributeAndPropertySets objects
	When Create catalog AddAttributeAndPropertyValues objects
	When Create catalog ItemKeys objects (MF)
	When Create catalog ItemTypes objects (MF)
	When Create catalog Units objects
	When Create catalog Units objects (MF)
	When Create catalog Items objects (MF)
	When Create chart of characteristic types AddAttributeAndProperty objects
	When Create catalog Stores objects
	When Create catalog Companies objects (Main company)
	When Create chart of characteristic types CurrencyMovementType objects
	When Create catalog Currencies objects
	When Create catalog BusinessUnits objects
	When Create catalog Countries objects
	When Create catalog IntegrationSettings objects
	When Create information register CurrencyRates records
	When Create catalog MFBillOfMaterials objects
	When Create catalog PlanningPeriods objects (MF)
	When Create catalog ObjectStatuses objects
	When Create catalog Stores objects
	When Create document SalesOrder objects (MF)
	And I execute 1C:Enterprise script at server
		| "Doc = Documents.SalesOrder.FindByNumber(12).GetObject();"   |
		| "Doc.Write(DocumentWriteMode.Posting);"                      |
	When Create document ProductionPlanning objects (first period)
	When Create document Production objects (reservation)
	And I execute 1C:Enterprise script at server
		| "Doc = Documents.Production.FindByNumber(12).GetObject();"   |
		| "Doc.Date = CurrentDate();"                                  |
		| "Doc.Write(DocumentWriteMode.Posting);"                      |
	* Create Production planning closing
		Given I open hyperlink "e1cib/list/Document.ProductionPlanning"
		And I go to line in "List" table
			| 'Number'    |
			| '12'        |
		And I click "Production planning closing" button
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "BusinessUnit" became equal to "Shop 01"
		Then the form attribute named "ProductionPlanning" became equal to "Production planning 12 dated 01.01.2021 16:47:36"
		Then the form attribute named "PlanningPeriod" became equal to "First"
		And the editing text of form attribute named "PlanningPeriodStartDate" became equal to "20.01.2021"
		And the editing text of form attribute named "PlanningPeriodEndDate" became equal to "25.01.2021"
		Then the form attribute named "Author" became equal to "en description is empty"
		And I click "Post" button
		And I close all client application windows
		



		
				

		
				
