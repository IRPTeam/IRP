#language: en
@tree
@Positive
@PreliminaryStock


Feature: preliminary stock (purchase - sales)

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: _997001 filling in test data base preliminary stock (purchase - sales)
When set True value to the constant
When set True value to the constant Use consolidated retail sales
When set True value to the constant Use commission trading
When set True value to the constant Use accounting
When set True value to the constant Use salary
When set True value to the constant Use retail orders
When set True value to the constant Use fixed assets
When Create catalog ExternalDataProc objects (test data base)
* Add ExternalDataProc
		* Discount
				Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
				And I go to line in "List" table
						| 'Description'            |
						| 'DocumentDiscount'       |
				And I select current line in "List" table
				And I select external file "$Path$/DataProcessor/DocumentDiscount.epf"
				And I click the button named "FormAddExtDataProc"
				And I input "" text in "Path to plugin for test" field
				And I click "Save and close" button
				And I wait "Plugins (create)" window closing in 5 seconds
When Create catalog AddAttributeAndPropertySets objects (test data base)
When Create catalog AddAttributeAndPropertyValues objects (test data base)
When Create catalog IDInfoAddresses objects (test data base)
When Create catalog BankTerms objects (test data base)
When Create catalog BusinessUnits objects (test data base)
When Create catalog CancelReturnReasons objects (test data base)
When Create catalog CashStatementStatuses objects (test data base)
When Create catalog CashAccounts objects (test data base)
When Create catalog BillOfMaterials objects (test data base)
When Create catalog Companies objects (test data base)
When Create catalog ConfigurationMetadata objects (test data base)
When Create catalog IDInfoSets objects (test data base)
When Create catalog Countries objects (test data base)
When Create catalog Currencies objects (test data base)
When Create catalog DataBaseStatus objects (test data base)
When Create catalog ExpenseAndRevenueTypes objects (test data base)
When Create catalog IntegrationSettings objects (test data base)
When Create catalog ItemKeys objects (test data base)
When Create catalog ItemTypes objects (test data base)
When Create catalog Units objects (test data base)
When Create catalog Items objects (test data base)
When Create catalog ObjectStatuses objects (test data base)
When Create catalog CurrencyMovementSets objects (test data base)
When Create catalog PartnerSegments objects (test data base)
When Create catalog Agreements objects (test data base)
When Create catalog Partners objects (test data base)
When Create catalog PartnersBankAccounts objects (test data base)
When Create catalog PaymentTerminals objects (test data base)
When Create catalog PaymentSchedules objects (test data base)
When Create catalog PaymentTypes objects (test data base)
When Create catalog PriceTypes objects (test data base)
When Create catalog RetailCustomers objects (test data base)	
When Create catalog SpecialOfferTypes objects (test data base)
When Create catalog SpecialOffers objects (test data base)
When Create catalog Specifications objects (test data base)
When Create catalog Stores objects (test data base)
When Create catalog TaxRates objects (test data base)
When Create catalog Taxes objects (test data base)
When Create catalog SerialLotNumbers objects (test data base)
When Create information register Taxes records (test data base)
When Create catalog AccrualAndDeductionTypes objects (test data base)
When Create catalog EmployeePositions objects (test data base)
When Create catalog FixedAssetsLedgerTypes objects (test data base)
When Create catalog DepreciationSchedules objects (test data base)
When Create catalog FixedAssets objects (test data base)
When Create catalog ItemSegments objects (test data base)
When Create catalog EmployeeSchedule objects (test data base)
When Create catalog LegalNameContracts objects (test data base)
When Create catalog ObjectLocations objects (test data base)
When Create catalog Projects objects (test data base)
When Create catalog UnitsOfMeasurement objects (test data base)
When Create catalog Vehicles objects (test data base)
* Tax settings
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		And I go to line in "List" table
			| 'Description'         |
			| 'Own company 2'       |
		And I select current line in "List" table
		And I move to "Tax types" tab
		And I go to line in "CompanyTaxes" table
			| 'Tax'       |
			| 'VAT'       |
		And I select current line in "CompanyTaxes" table
		And I click Open button of "Tax" field
		And I select "VAT" exact value from the drop-down list named "Kind"
		And I click "Save and close" button
		And I set checkbox named "CompanyTaxesIncludeToLandedCost" in "CompanyTaxes" table
		And I finish line editing in "CompanyTaxes" table	
		And I click "Save and close" button
		And I close all client application windows
When Create catalog InterfaceGroups objects (test data base)
When Create catalog AccessGroups objects (test data base)
When Create catalog AccessProfiles objects (test data base)
When Create catalog UserGroups objects (test data base)
When Create catalog Users objects (test data base)
When Create catalog Workstations objects (test data base)
When Create catalog PlanningPeriods objects (test data base)
When Create chart of characteristic types AddAttributeAndProperty objects (test data base)
When Create chart of characteristic types IDInfoTypes objects (test data base)
When Create chart of characteristic types CustomUserSettings objects (test data base)
When Create chart of characteristic types CurrencyMovementType objects (test data base)
When Create information register BundleContents records (test data base)
When Create information register BranchBankTerms records (test data base)
When Create information register CurrencyRates records (test data base)
When Create information register Barcodes records (test data base)
When Create information register PartnerSegments records (test data base)
When Create information register TaxSettings records (test data base)
When Create information register UserSettings records (test data base)
When Create catalog PartnerItems objects (test data base)
When Create documents for preliminary stock (Purchase - Sales)
And I execute 1C:Enterprise script at server
	| "Documents.PurchaseOrder.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
And I execute 1C:Enterprise script at server
	| "Documents.PurchaseOrder.FindByNumber(172).GetObject().Write(DocumentWriteMode.Posting);"    |
* Load data for Accounting system
	When Create chart of characteristic types AccountingExtraDimensionTypes objects (test data base)
	When Create chart of accounts Basic objects with LedgerTypeVariants (Basic LTV) (test data base)
	When Create information register T9011S_AccountsCashAccount records (Basic LTV) (test data base)
	When Create information register T9014S_AccountsExpenseRevenue records (Basic LTV) (test data base)
	When Create information register T9010S_AccountsItemKey records (Basic LTV) (test data base)
	When Create information register T9012S_AccountsPartner records (Basic LTV) (test data base)
	When Create information register T9013S_AccountsTax records (Basic LTV) (test data base)
* Additional table control
	Given I open hyperlink "e1cib/app/DataProcessor.FunctionalOptionSettings"	
	And I go to line in "FunctionalOptions" table
		| "Option"                                |
		| "Use additional table control document" |
	And I set "Use" checkbox in "FunctionalOptions" table
	And I click "Save" button
When set False value to the constant DisableLinkedRowsIntegrity
* Stock inventory control
	Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.CustomUserSettings"
	And I click the button named "ListTemplate_R4050B_StockInventory"
	And I input "CheckBalance_R4050B_StockInventory" text in the field named "Description_en"
	And I click the button named "FormWriteAndClose"
	Given I open hyperlink "e1cib/list/Catalog.Users"
	And I go to line in "List" table
		| "Description" |
		| "CI"          |
	And I click the button named "FormSettings"
	And I go to line in "MetadataTree" table
		| "Group name"                         | "Use" |
		| "CheckBalance_R4050B_StockInventory" | "No"  |
	And I select current line in "MetadataTree" table
	And I select "Yes" exact value from the drop-down list named "MetadataTreeValue" in "MetadataTree" table
	And I finish line editing in "MetadataTree" table
	And I click the button named "FormOk"	
And I close all client application windows

Scenario: _997002 check preparation (preliminary stock (purchase - sales))
	When check preparation

Scenario: _997003 check case GR-SI-PI (with preliminary, with sales)
	And I close all client application windows
	* Post GR
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Check preliminary cost
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		Then "Select period" window is opened
		And I input "01.07.2025" text in the field named "DateBegin"
		And I input "30.07.2025" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click the button named "FormGenerate"
		And "Result" spreadsheet document contains "Preliminary_001" template lines by template
		And I close all client application windows
	* Post SI (preliminary stock sales)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Check preliminary cost
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		Then "Select period" window is opened
		And I input "01.07.2025" text in the field named "DateBegin"
		And I input "30.07.2025" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click the button named "FormGenerate"
		And "Result" spreadsheet document contains "Preliminary_002" template lines by template
		And I close all client application windows	
	* Post PI
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Check preliminary cost
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		Then "Select period" window is opened
		And I input "01.07.2025" text in the field named "DateBegin"
		And I input "30.07.2025" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click the button named "FormGenerate"
		And "Result" spreadsheet document contains "Preliminary_003" template lines by template
		And I close all client application windows
				

Scenario: _997004 check case GR-PI-SI (with preliminary)
	And I close all client application windows
	* Post GR
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(172).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Check preliminary cost
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		Then "Select period" window is opened
		And I input "01.07.2025" text in the field named "DateBegin"
		And I input "30.07.2025" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| "Item"               | "Item key"  |
			| "Item with item key" | "M/Color 2" |
		And I select current line in "List" table
		And I click the button named "FormGenerate"
		And "Result" spreadsheet document contains "Preliminary_011" template lines by template
		And I close all client application windows
	* Post PI (preliminary stock sales)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(172).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Check preliminary cost
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		Then "Select period" window is opened
		And I input "01.07.2025" text in the field named "DateBegin"
		And I input "30.07.2025" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| "Item"               | "Item key"  |
			| "Item with item key" | "M/Color 2" |
		And I select current line in "List" table
		And I click the button named "FormGenerate"
		And "Result" spreadsheet document contains "Preliminary_012" template lines by template
		And I close all client application windows	
	* Post SI
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(172).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Check preliminary cost
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		Then "Select period" window is opened
		And I input "01.07.2025" text in the field named "DateBegin"
		And I input "30.07.2025" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| "Item"               | "Item key"  |
			| "Item with item key" | "M/Color 2" |
		And I select current line in "List" table
		And I click the button named "FormGenerate"
		And "Result" spreadsheet document contains "Preliminary_013" template lines by template
		And I close all client application windows
				
				
Scenario: _997005 check case GR-GR-SI-SI-PI (with preliminary)
	And I close all client application windows
	* Post GR
		Given I open hyperlink "e1cib/list/Document.GoodsReceipt"
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(173).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(174).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Check preliminary cost
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		Then "Select period" window is opened
		And I input "01.07.2025" text in the field named "DateBegin"
		And I input "30.07.2025" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| "Item"                                                                     | "Item key"  |
			| "Item 1 with serial lot number and marking code without check code string" | "S/Color 3" |
		And I select current line in "List" table
		And I click the button named "FormGenerate"
		And "Result" spreadsheet document contains "Preliminary_021" template lines by template
		And I close all client application windows
	* Post SI (preliminary stock sales)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(173).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(174).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Check preliminary cost
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		Then "Select period" window is opened
		And I input "01.07.2025" text in the field named "DateBegin"
		And I input "30.07.2025" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| "Item"                                                                     | "Item key"  |
			| "Item 1 with serial lot number and marking code without check code string" | "S/Color 3" |
		And I select current line in "List" table
		And I click the button named "FormGenerate"
		And "Result" spreadsheet document contains "Preliminary_022" template lines by template
		And I close all client application windows	
	* Post PI
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(173).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Check preliminary cost
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		Then "Select period" window is opened
		And I input "01.07.2025" text in the field named "DateBegin"
		And I input "30.07.2025" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| "Item"                                                                     | "Item key"  |
			| "Item 1 with serial lot number and marking code without check code string" | "S/Color 3" |
		And I select current line in "List" table
		And I click the button named "FormGenerate"
		And "Result" spreadsheet document contains "Preliminary_023" template lines by template
		And I close all client application windows	

	
Scenario: _997006 check case GR-PI-GR-SI-SI-PI (with preliminary)
	And I close all client application windows
	* Post first GR and first PI
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(175).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(174).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Check preliminary cost
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		Then "Select period" window is opened
		And I input "01.07.2025" text in the field named "DateBegin"
		And I input "30.07.2025" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| "Item"                                                 | "Item key"  |
			| "Item 3 with serial lot number add new row after scan" | "S/Color 2" |
		And I select current line in "List" table
		And I click the button named "FormGenerate"
		And "Result" spreadsheet document contains "Preliminary_031" template lines by template
		And I close all client application windows
	* Post second GR and SI
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(176).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(175).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(176).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Check preliminary cost
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		Then "Select period" window is opened
		And I input "01.07.2025" text in the field named "DateBegin"
		And I input "30.07.2025" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| "Item"                                                 | "Item key"  |
			| "Item 3 with serial lot number add new row after scan" | "S/Color 2" |
		And I select current line in "List" table
		And I click the button named "FormGenerate"
		And "Result" spreadsheet document contains "Preliminary_032" template lines by template
		And I close all client application windows
	* Post second PI
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(175).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Check preliminary cost
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		Then "Select period" window is opened
		And I input "01.07.2025" text in the field named "DateBegin"
		And I input "30.07.2025" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| "Item"                                                 | "Item key"  |
			| "Item 3 with serial lot number add new row after scan" | "S/Color 2" |
		And I select current line in "List" table
		And I click the button named "FormGenerate"
		And "Result" spreadsheet document contains "Preliminary_033" template lines by template
		And I close all client application windows
	
		
Scenario: _997007 check case GR-IT-IT-SI-PI (with preliminary)	
	And I close all client application windows
	* Post GR and IT
		And I execute 1C:Enterprise script at server
			| "Documents.GoodsReceipt.FindByNumber(177).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.InventoryTransfer.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.InventoryTransfer.FindByNumber(2).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Check preliminary cost
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		Then "Select period" window is opened
		And I input "01.07.2025" text in the field named "DateBegin"
		And I input "30.07.2025" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| "Item"                                             | "Item key"  |
			| "Item 2 with serial lot number and good code data" | "S/Color 2" |
		And I select current line in "List" table
		And I click the button named "FormGenerate"
		And "Result" spreadsheet document contains "Preliminary_041" template lines by template
		And I close all client application windows	
	* Post SI (from two stores)
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(177).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Check preliminary cost
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		Then "Select period" window is opened
		And I input "01.07.2025" text in the field named "DateBegin"
		And I input "30.07.2025" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| "Item"                                             | "Item key"  |
			| "Item 2 with serial lot number and good code data" | "S/Color 2" |
		And I select current line in "List" table
		And I click the button named "FormGenerate"
		And "Result" spreadsheet document contains "Preliminary_042" template lines by template
		And I close all client application windows					
	* Post PI
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(176).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Check preliminary cost
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(171).GetObject().Write(DocumentWriteMode.Posting);"    |
		Given I open hyperlink "e1cib/app/Report.R6020_BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		Then "Select period" window is opened
		And I input "01.07.2025" text in the field named "DateBegin"
		And I input "30.07.2025" text in the field named "DateEnd"
		And I click the button named "Select"
		And I click Choice button of the field named "SettingsComposerUserSettingsItem1Value"
		And I go to line in "List" table
			| "Item"                                             | "Item key"  |
			| "Item 2 with serial lot number and good code data" | "S/Color 2" |
		And I select current line in "List" table
		And I click the button named "FormGenerate"
		And "Result" spreadsheet document contains "Preliminary_043" template lines by template
		And I close all client application windows