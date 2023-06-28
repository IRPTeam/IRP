#language: en
@tree
@Positive
@Other


Feature: data history

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _602700 preparation (data history)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
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
		When Create information register Barcodes records
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description"            |
				| "TaxCalculateVAT_TR"     |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
	When Create document PurchaseOrder objects (check movements, GR before PI, not Use receipt sheduling)

Scenario: _6027001 check preparation
	When check preparation 

Scenario: _602701 check data history for catalog (Partners)
	* Data history settings
		Given I open hyperlink "e1cib/app/DataProcessor.DataHistory"
		And I go to line in "MetadataTree" table
			| 'Name'        |
			| 'Catalogs'    |
		And I expand current line in "MetadataTree" table
		And I go to line in "MetadataTree" table
			| 'Name'        |
			| 'Partners'    |
		And I set "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And in the table "MetadataTree" I click "Save settings" button
		And in the table "MetadataTree" I click "Update data history" button
	* Check 
		Given I open hyperlink "e1cib/list/Catalog.Partners"	
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		Then "Ferron BP (Partner)" window is opened
		And I click "Save" button
		And I click "Change history" button
		And "Versions" table contains lines
			| '№'   | 'Date'   | 'Author'    |
			| '*'   | '*'      | '*'         |
	And I close all client application windows
	
Scenario: _602702 check data history for document (Purchase order)	
	And I close all client application windows
	* Data history settings
		Given I open hyperlink "e1cib/app/DataProcessor.DataHistory"
		And I go to line in "MetadataTree" table
			| 'Name'         |
			| 'Documents'    |
		And I activate "Name" field in "MetadataTree" table
		And I expand current line in "MetadataTree" table	
		And I go to line in "MetadataTree" table
			| 'Name'             |
			| 'PurchaseOrder'    |
		And I set "Use" checkbox in "MetadataTree" table
		And I finish line editing in "MetadataTree" table
		And in the table "MetadataTree" I click "Save settings" button
		And in the table "MetadataTree" I click "Update data history" button
	* Check 
		Given I open hyperlink "e1cib/list/Document.PurchaseOrder"
		And I go to line in "List" table
			| 'Number'   | 'Date'                   |
			| '116'      | '12.02.2021 12:44:59'    |
		And I select current line in "List" table
		And I click "Post" button
		And I click "Change history" button
		And "Versions" table contains lines
			| '№'   | 'Date'   | 'Author'    |
			| '*'   | '*'      | '*'         |
	And I close all client application windows
		
				
		
				
		
				
		
				
				

