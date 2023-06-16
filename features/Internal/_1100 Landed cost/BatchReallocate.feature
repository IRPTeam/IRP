#language: en
@tree
@BatchReallocate

Feature: Landed cost (batch reallocate)

Variables:
import "Variables.feature"

Background:
	Given I open new TestClient session or connect the existing one


Scenario: _0050 preparation
	When set True value to the constant
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
		When Create catalog ReportOptions objects (landed cost) 
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
		When Create catalog PaymentTypes objects
		And Delay 10
		When update ItemKeys (LC)
	* Add plugin for taxes calculation
			When add Plugin for tax calculation (LC)
		When update tax settings (LC)

	* Landed cost currency movement type for company
		
		Given I open hyperlink "e1cib/list/Catalog.Companies"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I select "Company" exact value from the drop-down list named "Type"
		And I move to "Landed cost" tab
		And I click Select button of "Currency movement type" field
		And I go to line in "List" table
			| 'Currency'   | 'Deferred calculation'   | 'Description'      | 'Reference'        | 'Source'         | 'Type'     |
			| 'TRY'        | 'No'                     | 'Local currency'   | 'Local currency'   | 'Forex Seling'   | 'Legal'    |
		And I select current line in "List" table
		Then the form attribute named "LandedCostCurrencyMovementType" became equal to "Local currency"
		And I click "Save and close" button
		And I wait "Main Company (Company) *" window closing in 20 seconds
		Then "Companies" window is opened
		And I go to line in "List" table
			| 'Description'       |
			| 'Second Company'    |
		And I select current line in "List" table
		And I select "Company" exact value from the drop-down list named "Type"
		And I move to "Landed cost" tab
		And I click Select button of "Currency movement type" field
		And I go to line in "List" table
			| 'Currency'   | 'Deferred calculation'   | 'Description'      | 'Reference'        | 'Source'         | 'Type'     |
			| 'TRY'        | 'No'                     | 'Local currency'   | 'Local currency'   | 'Forex Seling'   | 'Legal'    |
		And I select current line in "List" table
		Then the form attribute named "LandedCostCurrencyMovementType" became equal to "Local currency"
		And I click "Save and close" button
		And I wait "Second Company (Company) *" window closing in 20 seconds
	* Load documents
		When Create documents Batch relocation (LC)
		When Create document AdditionalCostAllocation, PurchaseInvoice (additional cost, batch realocate)
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(1011).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.ItemStockAdjustment.FindByNumber(161).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(1011).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(1012).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1011).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1012).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailSalesReceipt.FindByNumber(1011).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.RetailReturnReceipt.FindByNumber(1011).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.PurchaseInvoice.FindByNumber(1012).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.AdditionalCostAllocation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.AdditionalCostAllocation.FindByNumber(1).GetObject().Write(DocumentWriteMode.Posting);"    |
		When Create document StockAdjustmentAsSurplus, SalesInvoice, Sales return (batch realocate)
		And I close all client application windows
	
Scenario: _00501 check preparation
	When check preparation

Scenario: _0052 create Calculation movements cost (batch reallocate)
	And I close all client application windows
	* Create Calculation movement costs
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I click the button named "FormCreate"
		And I click Choice button of the field named "Company"
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I select "Landed cost (batch reallocate)" exact value from "Calculation mode" drop-down list
		And I input "30.05.2022" text in "Begin date" field
		And I input "30.05.2022" text in "End date" field
		And I click "Post and close" button
		And I wait "Calculation movement costs (create) *" window closing in 20 seconds
	* Check batch balance calculation
		Given I open hyperlink "e1cib/app/Report.BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		And I click "Generate" button
		Given "Result" spreadsheet document is equal to "BatchReallocate1"
		And I close all client application windows
		

Scenario: _0053 clear posting CalculationMovementCosts and check BatchReallocateIncoming and BatchReallocateOutgoing unpost
	* Unpost CalculationMovementCosts
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to the last line in "List" table
		And in the table "List" I click the button named "ListContextMenuUndoPosting"
	* Check unpost BatchReallocateIncoming and BatchReallocateOutgoing
		Given I open hyperlink "e1cib/list/Document.BatchReallocateIncoming"
		And "List" table became equal
			| 'Number'   | 'Batch reallocate'   | 'Date'   | 'Company'   | 'Document'   | 'Outgoing'    |
			| '1'        | ''                   | '*'      | ''          | ''           | ''            |
			| '2'        | ''                   | '*'      | ''          | ''           | ''            |
			| '3'        | ''                   | '*'      | ''          | ''           | ''            |
		Given I open hyperlink "e1cib/list/Document.BatchReallocateOutgoing"
		And "List" table became equal
			| 'Number'   | 'Batch reallocate'   | 'Date'   | 'Company'   | 'Document'   | 'Incoming'    |
			| '1'        | ''                   | '*'      | ''          | ''           | ''            |
			| '2'        | ''                   | '*'      | ''          | ''           | ''            |
			| '3'        | ''                   | '*'      | ''          | ''           | ''            |
	* Post CalculationMovementCosts
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to the last line in "List" table
		And in the table "List" I click the button named "ListContextMenuPost"
	* Check post BatchReallocateIncoming and BatchReallocateOutgoing
		Given I open hyperlink "e1cib/list/Document.BatchReallocateIncoming"
		And "List" table contains lines
			| 'Number'   | 'Batch reallocate'                 | 'Date'   | 'Company'          | 'Document'                     | 'Outgoing'                        |
			| '1'        | 'Calculation movement costs 22*'   | '*'      | 'Second Company'   | 'Item stock adjustment 161*'   | 'Batch reallocate outgoing 1*'    |
			| '2'        | 'Calculation movement costs 22*'   | '*'      | 'Second Company'   | 'Sales invoice 1 011*'         | 'Batch reallocate outgoing 2*'    |
			| '3'        | 'Calculation movement costs 22*'   | '*'      | 'Second Company'   | 'Sales invoice 1 012*'         | 'Batch reallocate outgoing 3*'    |
		Given I open hyperlink "e1cib/list/Document.BatchReallocateOutgoing"
		And "List" table contains lines
			| 'Number'   | 'Batch reallocate'                 | 'Date'   | 'Company'        | 'Document'                     | 'Incoming'                        |
			| '1'        | 'Calculation movement costs 22*'   | '*'      | 'Main Company'   | 'Item stock adjustment 161*'   | 'Batch reallocate incoming 1*'    |
			| '2'        | 'Calculation movement costs 22*'   | '*'      | 'Main Company'   | 'Sales invoice 1 011*'         | 'Batch reallocate incoming 2*'    |
			| '3'        | 'Calculation movement costs 22*'   | '*'      | 'Main Company'   | 'Sales invoice 1 012*'         | 'Batch reallocate incoming 3*'    |
	* Mark for daletion CalculationMovementCosts
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Document.CalculationMovementCosts"
		And I go to the last line in "List" table
		And in the table "List" I click the button named "ListContextMenuSetDeletionMark"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
	* Check unpost BatchReallocateIncoming and BatchReallocateOutgoing
		Given I open hyperlink "e1cib/list/Document.BatchReallocateIncoming"
		And "List" table became equal
			| 'Number'   | 'Batch reallocate'   | 'Date'   | 'Company'   | 'Document'   | 'Outgoing'    |
			| '1'        | ''                   | '*'      | ''          | ''           | ''            |
			| '2'        | ''                   | '*'      | ''          | ''           | ''            |
			| '3'        | ''                   | '*'      | ''          | ''           | ''            |
		Given I open hyperlink "e1cib/list/Document.BatchReallocateOutgoing"
		And "List" table became equal
			| 'Number'   | 'Batch reallocate'   | 'Date'   | 'Company'   | 'Document'   | 'Incoming'    |
			| '1'        | ''                   | '*'      | ''          | ''           | ''            |
			| '2'        | ''                   | '*'      | ''          | ''           | ''            |
			| '3'        | ''                   | '*'      | ''          | ''           | ''            |
		And I close all client application windows
		
		
Scenario: _0054 check batch realocate with return (batch StockAdjustmentAsSurplus)	
	And I close all client application windows
	* Preparation
		And I execute 1C:Enterprise script at server
			| "Documents.StockAdjustmentAsSurplus.FindByNumber(21).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1013).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1014).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1015).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesInvoice.FindByNumber(1016).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.SalesReturn.FindByNumber(1013).GetObject().Write(DocumentWriteMode.Posting);"    |
		And I execute 1C:Enterprise script at server
			| "Documents.CalculationMovementCosts.FindByNumber(21).GetObject().Write(DocumentWriteMode.Posting);"    |
	* Check batch balance calculation
		Given I open hyperlink "e1cib/app/Report.BatchBalance"
		And I click "Select option..." button
		And I move to "Custom" tab
		And I activate field named "OptionsListReportOption" in "OptionsList" table
		And I select current line in "OptionsList" table
		Then "Batch balance (Test landed cost)" window is opened
		And I click Choice button of the field named "SettingsComposerUserSettingsItem0Value"
		Then "Select period" window is opened
		And I input "19.05.2023" text in the field named "DateBegin"
		And I input "19.05.2023" text in the field named "DateEnd"
		And I click the button named "Select"
		Then "Batch balance (Test landed cost)" window is opened
		And I click "Generate" button
		Given "Result" spreadsheet document is equal to "BatchReallocate2"
		And I close all client application windows 		
		
				
		
				

		
		
				

		
				
	
