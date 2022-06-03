#language: en
@tree
@BatchReallocate

Feature: Landed cost (batch reallocate)


Background:
	Given I open new TestClient session or connect the existing one


Scenario: _0050 preparation
	When set True value to the constant (LC)
	* Checking the availability of catalogs and batches registers
		Given I open hyperlink "e1cib/list/Catalog.BatchKeys"
		Given I open hyperlink "e1cib/list/Catalog.Batches"
		Given I open hyperlink "e1cib/list/InformationRegister.T6020S_BatchKeysInfo"
		Given I open hyperlink "e1cib/list/InformationRegister.T6010S_BatchesInfo"
		Given I open hyperlink "e1cib/list/AccumulationRegister.R6010B_BatchWiseBalance"
		Given I open hyperlink "e1cib/list/AccumulationRegister.R6040T_BatchShortageIncoming"
		Given I open hyperlink "e1cib/list/AccumulationRegister.R6030T_BatchShortageOutgoing"
		And I close all client application windows
	* Load data
		When Create catalog AddAttributeAndPropertySets objects (LC)
		When Create catalog CancelReturnReasons objects (LC)
		When Create catalog AddAttributeAndPropertyValues objects (LC)
		When Create catalog IDInfoAddresses objects (LC)
		When Create catalog BusinessUnits objects (LC)
		When Create catalog Companies objects (LC)
		When Create catalog ConfigurationMetadata objects (LC)
		When Create catalog Countries objects (LC)
		When Create catalog Currencies objects (LC)
		When Create catalog ExpenseAndRevenueTypes objects (LC)
		When Create catalog IntegrationSettings objects (LC)
		When Create catalog ItemKeys objects (LC)
		When Create catalog ItemSegments objects (LC)
		When Create catalog SerialLotNumbers objects (LC)
		When Create catalog ItemTypes objects (LC)
		When Create catalog Units objects (LC)
		When Create catalog Items objects (LC)
		When Create catalog CurrencyMovementSets objects (LC)
		When Create catalog ObjectStatuses objects (LC)
		When Create catalog PartnerSegments objects (LC)
		When Create catalog Agreements objects (LC)
		When Create catalog Partners objects (LC)
		When Create catalog ExternalDataProc objects (LC)
		When Create catalog PriceKeys objects (LC)
		When Create catalog PriceTypes objects (LC)
		When Create catalog Specifications objects (LC)
		When Create catalog Stores objects (LC)
		When Create catalog TaxAnalytics objects (LC)
		When Create catalog TaxRates objects (LC)
		When Create catalog Taxes objects (LC)
		When Create catalog InterfaceGroups objects (LC)
		When Create catalog AccessGroups objects (LC)
		When Create catalog AccessProfiles objects (LC)
		When Create catalog UserGroups objects (LC)
		When Create catalog Users objects (LC)
		When Create document PriceList objects (LC)
		When Create chart of characteristic types AddAttributeAndProperty objects (LC)
		When Create chart of characteristic types CustomUserSettings objects (LC)
		When Create chart of characteristic types CurrencyMovementType objects (LC)
		When Create information register Taxes records (LC)
		When Create information register CurrencyRates records (LC)
		When Create information register Barcodes records (LC)
		When Create information register PricesByItemKeys records (LC)
		When Create information register PricesByItems records (LC)
		When Create information register PricesByProperties records (LC)
		When Create information register TaxSettings records (LC)
		When Create information register UserSettings records (LC)
		And Delay 10
		When update ItemKeys (LC)
	* Add plugin for taxes calculation
			When add Plugin for tax calculation (LC)
		When update tax settings (LC)

	* Landed cost currency movement type for company
		
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I select "Company" exact value from the drop-down list named "Type"
		And I move to "External attributes" tab
		And I click Select button of "Landed cost currency movement type" field
		And I go to line in "List" table
			| 'Currency' | 'Deferred calculation' | 'Description'    | 'Reference'      | 'Source'       | 'Type'  |
			| 'TRY'      | 'No'                   | 'Local currency' | 'Local currency' | 'Forex Seling' | 'Legal' |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Main Company (Company) *" window closing in 20 seconds
		Then "Companies" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Second Company' |
		And I select current line in "List" table
		And I select "Company" exact value from the drop-down list named "Type"
		And I move to "External attributes" tab
		And I click Select button of "Landed cost currency movement type" field
		And I go to line in "List" table
			| 'Currency' | 'Deferred calculation' | 'Description'        | 'Reference'          | 'Source'       | 'Type'      |
			| 'USD'      | 'No'                   | 'Reporting currency' | 'Reporting currency' | 'Forex Seling' | 'Reporting' |
		And I go to line in "List" table
			| 'Currency' | 'Deferred calculation' | 'Description'    | 'Reference'      | 'Source'       | 'Type'  |
			| 'TRY'      | 'No'                   | 'Local currency' | 'Local currency' | 'Forex Seling' | 'Legal' |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Second Company (Company) *" window closing in 20 seconds
	* Load documents
		When Create documents Batch relocation (LC)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(1011).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(1011).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1011).GetObject().Write(DocumentWriteMode.Posting);" |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1012).GetObject().Write(DocumentWriteMode.Posting);" |
		And I close all client application windows
	

Scenario: _0052 create Calculation movements cost (batch reallocate)
	And I close all client application windows
	* Create Calculation movement costs
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'  |
			| 'Main Company' |
		And I select current line in "List" table
		And I select "Landed cost (batch reallocate)" exact value from "Calculation mode" drop-down list
		And I input "30.05.2022" text in "Begin date" field
		And I input "30.05.2022" text in "End date" field
		And I click "Post and close" button
		And I wait "Calculation movement costs (create) *" window closing in 20 seconds
		Then the number of "List" table lines is "равно" "1"
	* Check batch balance calculation
		Given I open hyperlink "e1cib/app/Report.BatchBalance"
		And I click "Run report" button
		Given "Result" spreadsheet document is equal to "BatchReallocate1"
		And I close all client application windows
		
		